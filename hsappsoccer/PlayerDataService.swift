import Foundation
import SwiftData

class PlayerDataService {
    static let shared = PlayerDataService()
    
    private init() {}
    
    func populatePlayers(context: ModelContext) {
        // Check if players already exist
        let descriptor = FetchDescriptor<Player>()
        let existingPlayers = try? context.fetch(descriptor)
        
        if let existing = existingPlayers, !existing.isEmpty {
            return // Players already exist
        }
        
        let players = createPlayerData()
        
        for playerData in players {
            let player = Player(
                id: playerData.id,
                name: playerData.name,
                position: playerData.position,
                team: playerData.team,
                league: playerData.league,
                points: playerData.points,
                goals: playerData.goals,
                assists: playerData.assists,
                passes: playerData.passes,
                cleanSheets: playerData.cleanSheets,
                saves: playerData.saves,
                yellowCards: playerData.yellowCards,
                redCards: playerData.redCards
            )
            context.insert(player)
        }
        
        try? context.save()
    }
    
    private func createPlayerData() -> [PlayerData] {
        return [
            // Forwards (FWD)
            PlayerData(id: "1", name: "Erling Haaland", position: "FWD", team: "Manchester City", league: "Premier League", points: 245, goals: 18, assists: 5, passes: 342, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "2", name: "Kylian Mbappé", position: "FWD", team: "PSG", league: "Ligue 1", points: 238, goals: 17, assists: 8, passes: 456, cleanSheets: 0, saves: 0, yellowCards: 1, redCards: 0),
            PlayerData(id: "3", name: "Harry Kane", position: "FWD", team: "Bayern Munich", league: "Bundesliga", points: 232, goals: 16, assists: 7, passes: 389, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "4", name: "Vinicius Jr", position: "FWD", team: "Real Madrid", league: "La Liga", points: 228, goals: 15, assists: 9, passes: 567, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "5", name: "Mohamed Salah", position: "FWD", team: "Liverpool", league: "Premier League", points: 225, goals: 14, assists: 8, passes: 478, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "6", name: "Victor Osimhen", position: "FWD", team: "Napoli", league: "Serie A", points: 218, goals: 13, assists: 6, passes: 234, cleanSheets: 0, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "7", name: "Lautaro Martínez", position: "FWD", team: "Inter", league: "Serie A", points: 212, goals: 12, assists: 7, passes: 345, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "8", name: "Robert Lewandowski", position: "FWD", team: "Barcelona", league: "La Liga", points: 208, goals: 11, assists: 5, passes: 289, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            
            // Midfielders (MID)
            PlayerData(id: "9", name: "Kevin De Bruyne", position: "MID", team: "Manchester City", league: "Premier League", points: 267, goals: 8, assists: 15, passes: 892, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "10", name: "Jude Bellingham", position: "MID", team: "Real Madrid", league: "La Liga", points: 254, goals: 12, assists: 11, passes: 756, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "11", name: "Bruno Fernandes", position: "MID", team: "Manchester United", league: "Premier League", points: 248, goals: 9, assists: 13, passes: 823, cleanSheets: 0, saves: 0, yellowCards: 6, redCards: 0),
            PlayerData(id: "12", name: "Martin Ødegaard", position: "MID", team: "Arsenal", league: "Premier League", points: 241, goals: 7, assists: 14, passes: 867, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "13", name: "Federico Valverde", position: "MID", team: "Real Madrid", league: "La Liga", points: 235, goals: 6, assists: 12, passes: 789, cleanSheets: 0, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "14", name: "Phil Foden", position: "MID", team: "Manchester City", league: "Premier League", points: 229, goals: 8, assists: 10, passes: 634, cleanSheets: 0, saves: 0, yellowCards: 1, redCards: 0),
            PlayerData(id: "15", name: "Bukayo Saka", position: "MID", team: "Arsenal", league: "Premier League", points: 223, goals: 7, assists: 9, passes: 567, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "16", name: "Pedri", position: "MID", team: "Barcelona", league: "La Liga", points: 217, goals: 5, assists: 11, passes: 712, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "17", name: "Frenkie de Jong", position: "MID", team: "Barcelona", league: "La Liga", points: 211, goals: 3, assists: 8, passes: 945, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "18", name: "Declan Rice", position: "MID", team: "Arsenal", league: "Premier League", points: 205, goals: 4, assists: 6, passes: 823, cleanSheets: 0, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "19", name: "Rodri", position: "MID", team: "Manchester City", league: "Premier League", points: 199, goals: 3, assists: 7, passes: 978, cleanSheets: 0, saves: 0, yellowCards: 6, redCards: 0),
            PlayerData(id: "20", name: "Joshua Kimmich", position: "MID", team: "Bayern Munich", league: "Bundesliga", points: 193, goals: 2, assists: 8, passes: 856, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            
            // Defenders (DEF)
            PlayerData(id: "21", name: "Virgil van Dijk", position: "DEF", team: "Liverpool", league: "Premier League", points: 189, goals: 3, assists: 2, passes: 567, cleanSheets: 12, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "22", name: "Ruben Dias", position: "DEF", team: "Manchester City", league: "Premier League", points: 183, goals: 2, assists: 1, passes: 634, cleanSheets: 14, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "23", name: "William Saliba", position: "DEF", team: "Arsenal", league: "Premier League", points: 177, goals: 2, assists: 0, passes: 589, cleanSheets: 11, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "24", name: "Antonio Rüdiger", position: "DEF", team: "Real Madrid", league: "La Liga", points: 171, goals: 1, assists: 2, passes: 456, cleanSheets: 13, saves: 0, yellowCards: 6, redCards: 0),
            PlayerData(id: "25", name: "Matthijs de Ligt", position: "DEF", team: "Bayern Munich", league: "Bundesliga", points: 165, goals: 2, assists: 1, passes: 478, cleanSheets: 10, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "26", name: "Aurélien Tchouaméni", position: "DEF", team: "Real Madrid", league: "La Liga", points: 159, goals: 1, assists: 3, passes: 567, cleanSheets: 9, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "27", name: "John Stones", position: "DEF", team: "Manchester City", league: "Premier League", points: 153, goals: 1, assists: 2, passes: 634, cleanSheets: 12, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "28", name: "Alessandro Bastoni", position: "DEF", team: "Inter", league: "Serie A", points: 147, goals: 0, assists: 4, passes: 523, cleanSheets: 11, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "29", name: "Kim Min-jae", position: "DEF", team: "Bayern Munich", league: "Bundesliga", points: 141, goals: 1, assists: 1, passes: 456, cleanSheets: 10, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "30", name: "João Cancelo", position: "DEF", team: "Barcelona", league: "La Liga", points: 135, goals: 0, assists: 5, passes: 678, cleanSheets: 8, saves: 0, yellowCards: 6, redCards: 0),
            
            // Goalkeepers (GK)
            PlayerData(id: "31", name: "Alisson", position: "GK", team: "Liverpool", league: "Premier League", points: 187, goals: 0, assists: 0, passes: 234, cleanSheets: 12, saves: 89, yellowCards: 1, redCards: 0),
            PlayerData(id: "32", name: "Ederson", position: "GK", team: "Manchester City", league: "Premier League", points: 181, goals: 0, assists: 1, passes: 345, cleanSheets: 14, saves: 67, yellowCards: 2, redCards: 0),
            PlayerData(id: "33", name: "Thibaut Courtois", position: "GK", team: "Real Madrid", league: "La Liga", points: 175, goals: 0, assists: 0, passes: 189, cleanSheets: 13, saves: 78, yellowCards: 0, redCards: 0),
            PlayerData(id: "34", name: "Manuel Neuer", position: "GK", team: "Bayern Munich", league: "Bundesliga", points: 169, goals: 0, assists: 0, passes: 267, cleanSheets: 11, saves: 82, yellowCards: 1, redCards: 0),
            PlayerData(id: "35", name: "David Raya", position: "GK", team: "Arsenal", league: "Premier League", points: 163, goals: 0, assists: 0, passes: 456, cleanSheets: 10, saves: 71, yellowCards: 2, redCards: 0),
            PlayerData(id: "36", name: "Marc-André ter Stegen", position: "GK", team: "Barcelona", league: "La Liga", points: 157, goals: 0, assists: 0, passes: 234, cleanSheets: 9, saves: 76, yellowCards: 1, redCards: 0),
            PlayerData(id: "37", name: "Mike Maignan", position: "GK", team: "AC Milan", league: "Serie A", points: 151, goals: 0, assists: 0, passes: 198, cleanSheets: 8, saves: 84, yellowCards: 3, redCards: 0),
            PlayerData(id: "38", name: "Gianluigi Donnarumma", position: "GK", team: "PSG", league: "Ligue 1", points: 145, goals: 0, assists: 0, passes: 167, cleanSheets: 7, saves: 79, yellowCards: 2, redCards: 0),
            PlayerData(id: "39", name: "Emiliano Martínez", position: "GK", team: "Aston Villa", league: "Premier League", points: 139, goals: 0, assists: 0, passes: 234, cleanSheets: 6, saves: 91, yellowCards: 4, redCards: 0),
            PlayerData(id: "40", name: "Nick Pope", position: "GK", team: "Newcastle", league: "Premier League", points: 133, goals: 0, assists: 0, passes: 145, cleanSheets: 5, saves: 87, yellowCards: 1, redCards: 0),
            
            // Additional players for depth
            PlayerData(id: "41", name: "Lautaro Martínez", position: "FWD", team: "Inter", league: "Serie A", points: 127, goals: 9, assists: 4, passes: 234, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "42", name: "Marcus Rashford", position: "FWD", team: "Manchester United", league: "Premier League", points: 121, goals: 8, assists: 3, passes: 345, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "43", name: "Gabriel Jesus", position: "FWD", team: "Arsenal", league: "Premier League", points: 115, goals: 7, assists: 5, passes: 456, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "44", name: "Darwin Núñez", position: "FWD", team: "Liverpool", league: "Premier League", points: 109, goals: 6, assists: 4, passes: 234, cleanSheets: 0, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "45", name: "Christopher Nkunku", position: "FWD", team: "Chelsea", league: "Premier League", points: 103, goals: 5, assists: 6, passes: 345, cleanSheets: 0, saves: 0, yellowCards: 2, redCards: 0),
            
            PlayerData(id: "46", name: "Mason Mount", position: "MID", team: "Manchester United", league: "Premier League", points: 97, goals: 4, assists: 5, passes: 567, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "47", name: "Enzo Fernández", position: "MID", team: "Chelsea", league: "Premier League", points: 91, goals: 3, assists: 6, passes: 678, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "48", name: "Moises Caicedo", position: "MID", team: "Chelsea", league: "Premier League", points: 85, goals: 2, assists: 4, passes: 789, cleanSheets: 0, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "49", name: "Aurélien Tchouaméni", position: "MID", team: "Real Madrid", league: "La Liga", points: 79, goals: 1, assists: 5, passes: 567, cleanSheets: 0, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "50", name: "Eduardo Camavinga", position: "MID", team: "Real Madrid", league: "La Liga", points: 73, goals: 0, assists: 6, passes: 456, cleanSheets: 0, saves: 0, yellowCards: 4, redCards: 0),
            
            PlayerData(id: "51", name: "Ben White", position: "DEF", team: "Arsenal", league: "Premier League", points: 67, goals: 0, assists: 3, passes: 567, cleanSheets: 8, saves: 0, yellowCards: 5, redCards: 0),
            PlayerData(id: "52", name: "Joël Matip", position: "DEF", team: "Liverpool", league: "Premier League", points: 61, goals: 1, assists: 1, passes: 456, cleanSheets: 7, saves: 0, yellowCards: 3, redCards: 0),
            PlayerData(id: "53", name: "Nathan Aké", position: "DEF", team: "Manchester City", league: "Premier League", points: 55, goals: 0, assists: 2, passes: 345, cleanSheets: 9, saves: 0, yellowCards: 4, redCards: 0),
            PlayerData(id: "54", name: "Luke Shaw", position: "DEF", team: "Manchester United", league: "Premier League", points: 49, goals: 0, assists: 4, passes: 456, cleanSheets: 6, saves: 0, yellowCards: 2, redCards: 0),
            PlayerData(id: "55", name: "Reece James", position: "DEF", team: "Chelsea", league: "Premier League", points: 43, goals: 1, assists: 3, passes: 234, cleanSheets: 5, saves: 0, yellowCards: 6, redCards: 0),
            
            PlayerData(id: "56", name: "André Onana", position: "GK", team: "Manchester United", league: "Premier League", points: 37, goals: 0, assists: 0, passes: 123, cleanSheets: 4, saves: 67, yellowCards: 3, redCards: 0),
            PlayerData(id: "57", name: "Robert Sánchez", position: "GK", team: "Chelsea", league: "Premier League", points: 31, goals: 0, assists: 0, passes: 89, cleanSheets: 3, saves: 72, yellowCards: 2, redCards: 0),
            PlayerData(id: "58", name: "Kepa Arrizabalaga", position: "GK", team: "Real Madrid", league: "La Liga", points: 25, goals: 0, assists: 0, passes: 67, cleanSheets: 2, saves: 58, yellowCards: 1, redCards: 0),
            PlayerData(id: "59", name: "Yann Sommer", position: "GK", team: "Inter", league: "Serie A", points: 19, goals: 0, assists: 0, passes: 45, cleanSheets: 1, saves: 63, yellowCards: 2, redCards: 0),
            PlayerData(id: "60", name: "Lukáš Hrádecký", position: "GK", team: "Bayer Leverkusen", league: "Bundesliga", points: 13, goals: 0, assists: 0, passes: 34, cleanSheets: 0, saves: 49, yellowCards: 1, redCards: 0)
        ]
    }
}

// MARK: - Player Data Structure
struct PlayerData {
    let id: String
    let name: String
    let position: String
    let team: String
    let league: String
    let points: Int
    let goals: Int
    let assists: Int
    let passes: Int
    let cleanSheets: Int
    let saves: Int
    let yellowCards: Int
    let redCards: Int
} 