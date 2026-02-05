// TP2 - Card Game System
// Card Game Manager with Singleton Pattern

import Foundation

// Game Manager avec singleton pattern
final class CardGameManager {
    static let shared = CardGameManager()

    private init() {}

    func run() {
        print("Card Game: War")
        print("=================\n")

        let player1 = HumanPlayer(name: "Maurane")
        let player2 = AIPlayer(name: "Bob")

        let game = Game(player1: player1, player2: player2)
        game.play()
    }
}

final class Deck {
    var cards: [Card] = []

    init() {
        reset()
    }

    func shuffle() {
        cards.shuffle()
    }

    func draw() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeFirst()
    }

    func reset() {
        cards = Suit.allCases.flatMap { suit in
            Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }
        shuffle()
    }
}

protocol Player: AnyObject {
    var name: String { get }
    var hand: [Card] { get set }
    var score: Int { get set }

    func playCard() -> Card?
    func receiveCard(_ card: Card)
}

final class HumanPlayer: Player {
    let name: String
    var hand: [Card] = []
    var score: Int = 0

    init(name: String) {
        self.name = name
    }

    func playCard() -> Card? {
        guard !hand.isEmpty else { return nil }
        return hand.removeFirst()
    }

    func receiveCard(_ card: Card) {
        hand.append(card)
    }
}

final class AIPlayer: Player {
    let name: String
    var hand: [Card] = []
    var score: Int = 0

    init(name: String) {
        self.name = name
    }

    func playCard() -> Card? {
        guard !hand.isEmpty else { return nil }
        return hand.removeFirst()
    }

    func receiveCard(_ card: Card) {
        hand.append(card)
    }
}

final class Game {
    let player1: Player
    let player2: Player
    let deck: Deck

    private var roundNumber = 0

    init(player1: Player, player2: Player, deck: Deck = Deck()) {
        self.player1 = player1
        self.player2 = player2
        self.deck = deck
    }

    func dealCards() {
        print("Dealing cards...")

        var toggle = true
        while let card = deck.draw() {
            if toggle {
                player1.receiveCard(card)
            } else {
                player2.receiveCard(card)
            }
            toggle.toggle()
        }

        print("\(player1.name) received \(player1.hand.count) cards")
        print("\(player2.name) received \(player2.hand.count) cards\n")
    }

    @discardableResult
    func playRound() -> Bool {
        guard !player1.hand.isEmpty, !player2.hand.isEmpty else {
            return false
        }

        roundNumber += 1
        print("--- Round \(roundNumber) ---")

        guard let card1 = player1.playCard(), let card2 = player2.playCard() else {
            return false
        }

        print("\(player1.name) plays: \(card1.description)")
        print("\(player2.name) plays: \(card2.description)")

        let winner: Player
        if card1 > card2 {
            winner = player1
            print("\(winner.name) wins this round!")
        } else if card2 > card1 {
            winner = player2
            print("\(winner.name) wins this round!")
        } else {
            guard let warWinner = resolveWar() else {
                return false
            }
            winner = warWinner
            print("\(winner.name) wins the war!")
        }

        winner.score += 1
        print("Score: \(player1.name) \(player1.score) - \(player2.name) \(player2.score)\n")
        return true
    }

    func play() {
        dealCards()

        while !player1.hand.isEmpty && !player2.hand.isEmpty {
            _ = playRound()
        }

        print("=== GAME OVER ===")
        if player1.score > player2.score {
            print("Winner: \(player1.name) with \(player1.score) points!")
        } else if player2.score > player1.score {
            print("Winner: \(player2.name) with \(player2.score) points!")
        } else {
            print("It's a draw!")
        }
        print("Final score: \(player1.name) \(player1.score) - \(player2.name) \(player2.score)")
    }

    private func resolveWar() -> Player? {
        while true {
            print("War! Each player plays 3 cards...")

            if player1.hand.count < 4 {
                print("\(player1.name) does not have enough cards for war.")
                return player2
            }

            if player2.hand.count < 4 {
                print("\(player2.name) does not have enough cards for war.")
                return player1
            }

            for _ in 0..<3 {
                _ = player1.playCard()
                _ = player2.playCard()
            }

            guard let warCard1 = player1.playCard(), let warCard2 = player2.playCard() else {
                return nil
            }

            print("\(player1.name) plays: \(warCard1.description)")
            print("\(player2.name) plays: \(warCard2.description)")

            if warCard1 > warCard2 { return player1 }
            if warCard2 > warCard1 { return player2 }

            print("War continues!")
        }
    }
}

extension Array where Element == Card {
    func highest() -> Card? {
        self.max()
    }

    var cardsDescription: String {
        map(\.description).joined(separator: ", ")
    }
}
