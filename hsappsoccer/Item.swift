//
//  Item.swift
//  hsappsoccer
//
//  Created by Hamza on 7/31/25.
//

import Foundation
import SwiftData

// MARK: - Player Model
@Model
final class Player {
    var id: String
    var name: String
    var position: String
    var team: String
    var league: String
    var points: Int
    var goals: Int
    var assists: Int
    var passes: Int
    var cleanSheets: Int
    var saves: Int
    var yellowCards: Int
    var redCards: Int
    var isDrafted: Bool
    var draftedBy: String?
    var draftRound: Int?
    var draftPick: Int?
    
    init(id: String, name: String, position: String, team: String, league: String, 
         points: Int = 0, goals: Int = 0, assists: Int = 0, passes: Int = 0, 
         cleanSheets: Int = 0, saves: Int = 0, yellowCards: Int = 0, redCards: Int = 0) {
        self.id = id
        self.name = name
        self.position = position
        self.team = team
        self.league = league
        self.points = points
        self.goals = goals
        self.assists = assists
        self.passes = passes
        self.cleanSheets = cleanSheets
        self.saves = saves
        self.yellowCards = yellowCards
        self.redCards = redCards
        self.isDrafted = false
        self.draftedBy = nil
        self.draftRound = nil
        self.draftPick = nil
    }
}

// MARK: - Team Model
@Model
final class Team {
    var id: String
    var name: String
    var owner: String
    var players: [Player]
    var draftPosition: Int
    var isUserTeam: Bool
    
    init(id: String, name: String, owner: String, draftPosition: Int, isUserTeam: Bool = false) {
        self.id = id
        self.name = name
        self.owner = owner
        self.players = []
        self.draftPosition = draftPosition
        self.isUserTeam = isUserTeam
    }
}

// MARK: - League Model
@Model
final class League {
    var id: String
    var name: String
    var teams: [Team]
    var scoringSettings: ScoringSettings
    var draftSettings: DraftSettings
    var isActive: Bool
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.teams = []
        self.scoringSettings = ScoringSettings()
        self.draftSettings = DraftSettings()
        self.isActive = false
    }
}

// MARK: - Draft Model
@Model
final class Draft {
    var id: String
    var league: League
    var currentRound: Int
    var currentPick: Int
    var currentTeamIndex: Int
    var isSnake: Bool
    var isActive: Bool
    var draftOrder: [Int]
    var availablePlayers: [Player]
    var draftHistory: [DraftPick]
    
    init(id: String, league: League) {
        self.id = id
        self.league = league
        self.currentRound = 1
        self.currentPick = 1
        self.currentTeamIndex = 0
        self.isSnake = true
        self.isActive = false
        self.draftOrder = []
        self.availablePlayers = []
        self.draftHistory = []
    }
}

// MARK: - Supporting Models
struct ScoringSettings {
    var goalPoints: Double = 6.0
    var assistPoints: Double = 4.0
    var passPoints: Double = 0.5
    var cleanSheetPoints: Double = 4.0
    var savePoints: Double = 1.0
    var yellowCardPoints: Double = -1.0
    var redCardPoints: Double = -3.0
}

struct DraftSettings {
    var rounds: Int = 15
    var timePerPick: Int = 90 // seconds
    var positions: [String: Int] = [
        "GK": 2,
        "DEF": 5,
        "MID": 5,
        "FWD": 3
    ]
}

struct DraftPick {
    var round: Int
    var pick: Int
    var teamIndex: Int
    var player: Player
    var timestamp: Date
}

// MARK: - Legacy Item (keeping for compatibility)
@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
