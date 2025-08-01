import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            DraftBoardView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Draft")
                }
            TeamView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("My Team")
                }
            LeagueView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("League")
                }
        }
        .accentColor(.green)
    }
}

// MARK: - HomeView

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fantasy Soccer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        Text("PPR Style - Points Per Pass")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick Stats
                    HStack(spacing: 15) {
                        StatCard(title: "My Team", value: "8th", icon: "person.3.fill", color: .blue)
                        StatCard(title: "Points", value: "1,247", icon: "chart.line.uptrend.xyaxis", color: .green)
                        StatCard(title: "Record", value: "4-3", icon: "trophy.fill", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)
                        VStack(spacing: 8) {
                            ActivityRow(title: "Draft Completed", subtitle: "Your team is ready!", time: "2 hours ago")
                            ActivityRow(title: "Trade Accepted", subtitle: "Messi for Haaland", time: "1 day ago")
                            ActivityRow(title: "Week 7 Win", subtitle: "Beat Team Alpha 145-132", time: "3 days ago")
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}



// MARK: - TeamView

struct TeamView: View {
    @Query private var players: [Player]
    
    private var myPlayers: [Player] {
        players.filter { $0.isDrafted && $0.draftedBy == "Team A" }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Starters") {
                    ForEach(myPlayers) { player in
                        PlayerRow(player: player)
                    }
                }
                Section("Bench") {
                    Text("No bench players")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("My Team")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Manage") {
                        // Team management
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
}

// MARK: - LeagueView

struct LeagueView: View {
    @State private var standings = [
        TeamStanding(rank: 1, name: "Team Alpha", wins: 6, losses: 1, points: 1456),
        TeamStanding(rank: 2, name: "Team Beta", wins: 5, losses: 2, points: 1389),
        TeamStanding(rank: 3, name: "Team Gamma", wins: 5, losses: 2, points: 1324),
        TeamStanding(rank: 4, name: "Team Delta", wins: 4, losses: 3, points: 1287),
        TeamStanding(rank: 5, name: "Team Epsilon", wins: 4, losses: 3, points: 1245),
        TeamStanding(rank: 6, name: "Team Zeta", wins: 3, losses: 4, points: 1198),
        TeamStanding(rank: 7, name: "Team Eta", wins: 3, losses: 4, points: 1156),
        TeamStanding(rank: 8, name: "Your Team", wins: 4, losses: 3, points: 1247)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(standings) { team in
                    StandingRow(team: team)
                }
            }
            .navigationTitle("League Standings")
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct PlayerRow: View {
    let player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                HStack {
                    Text(player.position)
                        .font(.caption)
                        .padding(.horizontal, 8)
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

struct StandingRow: View {
    let team: TeamStanding
    
    var body: some View {
        HStack {
            Text("#\(team.rank)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(team.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(team.wins)-\(team.losses)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(team.points)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Data Models

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let position: String
    let team: String
    let points: Int
}

struct TeamStanding: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let wins: Int
    let losses: Int
    let points: Int
}

#Preview {
    ContentView()
}
