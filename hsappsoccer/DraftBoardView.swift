import SwiftUI
import SwiftData

struct DraftBoardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [Player]
    @Query private var teams: [Team]
    @Query private var drafts: [Draft]
    
    @State private var currentDraft: Draft?
    @State private var selectedPlayer: Player?
    @State private var showingPlayerDetail = false
    @State private var searchText = ""
    @State private var selectedPosition = "ALL"
    @State private var timer: Timer?
    @State private var timeRemaining = 60
    @State private var draftHistory: [DraftPick] = []
    @State private var currentPick = 1
    @State private var refreshTrigger = false
    
    private var teamsCount: Int { teams.count }
    private var rounds: Int { 15 } // Standard fantasy draft rounds
    
    private let positions = ["ALL", "GK", "DEF", "MID", "FWD"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Draft Header
                DraftHeaderView(
                    currentRound: currentDraft?.currentRound ?? 1,
                    currentPick: currentDraft?.currentPick ?? 1,
                    timeRemaining: timeRemaining,
                    currentTeam: getCurrentTeam()
                )
                
                // Draft Board
                DraftBoardGridView(
                    teams: teams,
                    draftHistory: currentDraft?.draftHistory ?? [],
                    currentPick: currentDraft?.currentPick ?? 1
                )
                
                // Search and Filter
                VStack(spacing: 8) {
                    TextField("Search players...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        ForEach(positions, id: \.self) { position in
                            Button(position) {
                                selectedPosition = position
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedPosition == position ? Color.purple : Color(.systemGray5))
                            .foregroundColor(selectedPosition == position ? .white : .primary)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                // Available Players
                AvailablePlayersView(
                    players: filteredPlayers,
                    onPlayerSelected: { player in
                        selectedPlayer = player
                        showingPlayerDetail = true
                    }
                )
            }
            .navigationTitle("Draft Board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Draft \(selectedPlayer?.name ?? "Player")") {
                        draftPlayer()
                    }
                    .disabled(selectedPlayer == nil || !isUserTurn())
                    .foregroundColor(.purple)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        print("🔄 DEBUG: Manual refresh triggered")
                        refreshTrigger.toggle()
                        
                        // Force context refresh
                        do {
                            try modelContext.save()
                            print("🔄 DEBUG: Context saved during refresh")
                        } catch {
                            print("❌ DEBUG: Context save error during refresh: \(error)")
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingPlayerDetail) {
                if let player = selectedPlayer {
                    PlayerDetailView(player: player)
                }
            }
            .onAppear {
                print("🎯 DEBUG: DraftBoardView appeared")
                print("🎯 DEBUG: Initial players count: \(players.count)")
                print("🎯 DEBUG: Initial teams count: \(teams.count)")
                print("🎯 DEBUG: Initial drafts count: \(drafts.count)")
                
                setupDraft()
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private var filteredPlayers: [Player] {
        print("🔍 DEBUG: Total players in database: \(players.count)")
        
        let available = players.filter { !$0.isDrafted }
        print("🔍 DEBUG: Available (not drafted) players: \(available.count)")
        
        let positionFiltered = selectedPosition == "ALL" ? available : available.filter { $0.position == selectedPosition }
        print("🔍 DEBUG: Position filtered players: \(positionFiltered.count)")
        
        let searchFiltered = searchText.isEmpty ? positionFiltered : positionFiltered.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.team.localizedCaseInsensitiveContains(searchText)
        }
        print("🔍 DEBUG: Search filtered players: \(searchFiltered.count)")
        
        let sorted = searchFiltered.sorted { $0.points > $1.points }
        print("🔍 DEBUG: Final sorted players: \(sorted.count)")
        
        return sorted
    }
    
    private func setupDraft() {
        // Check if draft already exists
        if let existingDraft = drafts.first {
            currentDraft = existingDraft
            draftHistory = currentDraft?.draftHistory ?? []
            currentPick = currentDraft?.currentPick ?? 1
        } else {
            // Create new draft
            createMockDraft()
        }
    }
    
    private func createMockDraft() {
        let league = League(id: "league1", name: "PPR Soccer League")
        modelContext.insert(league)
        
        // Create 12 teams
        for i in 1...12 {
            let team = Team(
                id: "team\(i)",
                name: "Team \(String(Character(UnicodeScalar(64 + i)!)))",
                owner: "Owner \(i)",
                draftPosition: i,
                isUserTeam: i == 1
            )
            league.teams.append(team)
            modelContext.insert(team)
        }
        
        let draft = Draft(id: "draft1", league: league)
        draft.isActive = true
        draft.draftOrder = Array(1...12)
        modelContext.insert(draft)
        currentDraft = draft
        
        try? modelContext.save()
    }
    
    private func getCurrentTeam() -> Team? {
        guard let draft = currentDraft else { return nil }
        let teamIndex = draft.currentTeamIndex
        return draft.league.teams[safe: teamIndex]
    }
    
    private func isUserTurn() -> Bool {
        guard let draft = currentDraft else { return false }
        let currentTeam = getCurrentTeam()
        return currentTeam?.isUserTeam == true
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Auto-draft or skip
                autoDraft()
            }
        }
    }
    
    private func draftPlayer() {
        guard let player = selectedPlayer,
              let draft = currentDraft,
              isUserTurn() else { return }
        
        // Mark player as drafted
        player.isDrafted = true
        player.draftedBy = getCurrentTeam()?.name
        player.draftRound = draft.currentRound
        player.draftPick = draft.currentPick
        
        // Add to draft history
        let draftPick = DraftPick(
            round: draft.currentRound,
            pick: draft.currentPick,
            teamIndex: draft.currentTeamIndex,
            player: player,
            timestamp: Date()
        )
        draft.draftHistory.append(draftPick)
        
        // Add to team roster
        getCurrentTeam()?.players.append(player)
        
        // Move to next pick
        moveToNextPick()
        
        // Save changes
        try? modelContext.save()
        
        // Reset timer
        timeRemaining = 90
        selectedPlayer = nil
    }
    
    private func autoDraft() {
        // Auto-draft best available player
        if let bestPlayer = filteredPlayers.first {
            selectedPlayer = bestPlayer
            draftPlayer()
        }
    }
    
    private func moveToNextPick() {
        guard let draft = currentDraft else { return }
        
        draft.currentPick += 1
        
        // Check if round is complete
        if draft.currentPick > 12 {
            draft.currentRound += 1
            draft.currentPick = 1
            // Reverse order for snake draft
            draft.draftOrder.reverse()
        }
        
        // Update current team index
        draft.currentTeamIndex = (draft.currentTeamIndex + 1) % 12
    }
}

// MARK: - Draft Header View
struct DraftHeaderView: View {
    let currentRound: Int
    let currentPick: Int
    let timeRemaining: Int
    let currentTeam: Team?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Round \(currentRound)")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text("Pick \(currentPick)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(timeRemaining)s")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(timeRemaining < 30 ? .red : .green)
                    Text("Time Left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let team = currentTeam {
                HStack {
                    Text("On the clock:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(team.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(team.isUserTeam ? .purple : .primary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

// MARK: - Draft Board Grid View
struct DraftBoardGridView: View {
    let teams: [Team]
    let draftHistory: [DraftPick]
    let currentPick: Int
    
    private let rounds = 15
    private let teamsCount = 12
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header row
                HStack(spacing: 0) {
                    Text("Team")
                        .frame(width: 80, height: 40)
                        .background(Color(.systemGray5))
                        .border(Color(.systemGray4), width: 0.5)
                    
                    ForEach(1...rounds, id: \.self) { round in
                        Text("R\(round)")
                            .frame(width: 60, height: 40)
                            .background(Color(.systemGray5))
                            .border(Color(.systemGray4), width: 0.5)
                    }
                }
                
                // Team rows
                ForEach(teams, id: \.id) { team in
                    HStack(spacing: 0) {
                        Text(team.name)
                            .frame(width: 80, height: 50)
                            .background(team.isUserTeam ? Color.purple.opacity(0.1) : Color.clear)
                            .border(Color(.systemGray4), width: 0.5)
                        
                        ForEach(1...rounds, id: \.self) { round in
                            let pick = getPickForTeam(team: team, round: round)
                            let player = getPlayerForPick(pick: pick)
                            
                            VStack {
                                if let player = player {
                                    Text(player.name)
                                        .font(.caption2)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                    Text(player.position)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("\(pick)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(width: 60, height: 50)
                            .background(getPickBackground(pick: pick))
                            .border(Color(.systemGray4), width: 0.5)
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func getPickForTeam(team: Team, round: Int) -> Int {
        let teamIndex = team.draftPosition - 1
        let isReverseRound = round % 2 == 0
        
        if isReverseRound {
            return (round - 1) * teamsCount + (teamsCount - teamIndex)
        } else {
            return (round - 1) * teamsCount + teamIndex + 1
        }
    }
    
    private func getPlayerForPick(pick: Int) -> Player? {
        return draftHistory.first { $0.pick == pick }?.player
    }
    
    private func getPickBackground(pick: Int) -> Color {
        if pick == currentPick {
            return .yellow.opacity(0.3)
        } else if pick < currentPick {
            return .green.opacity(0.1)
        } else {
            return .clear
        }
    }
}

// MARK: - Available Players View
struct AvailablePlayersView: View {
    let players: [Player]
    let onPlayerSelected: (Player) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Players List
            List {
                ForEach(players) { player in
                    AvailablePlayerRow(player: player)
                        .onTapGesture {
                            onPlayerSelected(player)
                        }
                }
            }
        }
    }
}

// MARK: - Available Player Row
struct AvailablePlayerRow: View {
    let player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                HStack {
                    Text(player.position)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(positionColor.opacity(0.2))
                        .foregroundColor(positionColor)
                        .cornerRadius(4)
                    Text(player.team)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(player.points)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text("PPR")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var positionColor: Color {
        switch player.position {
        case "GK": return .blue
        case "DEF": return .green
        case "MID": return .orange
        case "FWD": return .red
        default: return .gray
        }
    }
}

// MARK: - Player Detail View
struct PlayerDetailView: View {
    let player: Player
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Player Header
                    VStack(spacing: 8) {
                        Text(player.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(player.position)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(positionColor.opacity(0.2))
                                .foregroundColor(positionColor)
                                .cornerRadius(8)
                            
                            Text(player.team)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Stats Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatCard(title: "Goals", value: "\(player.goals)", icon: "soccerball", color: .green)
                        StatCard(title: "Assists", value: "\(player.assists)", icon: "hand.point.up", color: .blue)
                        StatCard(title: "Passes", value: "\(player.passes)", icon: "arrow.right", color: .orange)
                        StatCard(title: "Clean Sheets", value: "\(player.cleanSheets)", icon: "shield", color: .purple)
                        StatCard(title: "Saves", value: "\(player.saves)", icon: "hand.raised", color: .cyan)
                        StatCard(title: "PPR Points", value: "\(player.points)", icon: "chart.bar", color: .red)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Player Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Draft") {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
    
    private var positionColor: Color {
        switch player.position {
        case "GK": return .blue
        case "DEF": return .green
        case "MID": return .orange
        case "FWD": return .red
        default: return .gray
        }
    }
}



// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    DraftBoardView()
} 