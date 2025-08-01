# PPR Fantasy Soccer App

A fantasy soccer app with Points Per Pass (PPR) scoring system, similar to PPR fantasy football. Features a 12-team snake draft with a visual draft board like Underdog or Sleeper.

## Features

### 🏆 PPR Scoring System
- **Goals**: 6 points (like TDs in football)
- **Assists**: 4 points (like passing TDs)
- **Passes Completed**: 0.5 points each (like receptions)
- **Clean Sheets**: 4 points (DEF/GK)
- **Saves**: 1 point (GK)
- **Yellow/Red Cards**: -1/-3 points

### 📋 Draft Features
- **12-team snake draft** (1-12, then 12-1, etc.)
- **Visual draft board** showing all picks across 15 rounds
- **90-second timer** per pick with auto-draft
- **Player search and filtering** by position
- **Player detail view** with stats
- **Real-time draft progress** tracking

### 👥 Player Database
- 60+ real soccer players from top leagues
- Premier League, La Liga, Bundesliga, Serie A, Ligue 1
- Positions: GK, DEF, MID, FWD
- Realistic stats and PPR point calculations

## How to Test the Draft

1. **Launch the app** in Xcode
2. **Tap the "Draft" tab** to access the draft board
3. **View the draft board** showing all 12 teams and 15 rounds
4. **Search for players** using the search bar
5. **Filter by position** using the position buttons
6. **Tap on a player** to view detailed stats
7. **Draft players** when it's your turn (Team A)
8. **Watch the draft progress** in real-time

## Draft Board Layout

The draft board shows:
- **Header**: Current round, pick number, timer, and team on clock
- **Grid**: 12 teams × 15 rounds with drafted players
- **Available Players**: Searchable list of undrafted players
- **Visual indicators**: 
  - Yellow highlight for current pick
  - Green background for completed picks
  - Purple highlight for your team

## Technical Implementation

- **SwiftUI** for the user interface
- **SwiftData** for data persistence
- **Real-time updates** with timers and state management
- **Modular architecture** with separate views for each component

## Testing Scenarios

1. **Basic Draft Flow**: Draft players in order
2. **Search Functionality**: Find specific players
3. **Position Filtering**: Filter by GK, DEF, MID, FWD
4. **Timer Functionality**: Let timer expire for auto-draft
5. **Draft Board Navigation**: Scroll through the draft board
6. **Player Details**: View comprehensive player stats

## Next Steps

- Add multiplayer support
- Implement weekly matchups
- Add trade functionality
- Create league management features
- Add real-time scoring updates

---

**Note**: This is a demo version with mock data. In production, you would integrate with real soccer APIs for live stats and multiple user support. 