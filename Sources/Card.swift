// TP2 - Card Game System
// Card Model

import Foundation

// 1. ENUMS
// Code fourni - Décommenter et compléter

enum Suit: String, CaseIterable {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace

    var name: String {
        switch self {
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "Jack"
        case .queen: return "Queen Maurane"
        case .king: return "King"
        case .ace: return "Ace"
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// 2. STRUCT CARD
struct Card: Comparable {
    let rank: Rank
    let suit: Suit

    var description: String {
        "\(rank.name) of \(suit.rawValue)"
    }

    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.rank < rhs.rank
    }
}
