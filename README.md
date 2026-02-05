# TP2 - Card Game System

## Objectif

Créer un système complet de jeu de cartes (Bataille) avec architecture orientée objet.

## Règles du jeu Bataille

La Bataille est un jeu de cartes à deux joueurs:

1. Distribuer les 52 cartes équitablement aux 2 joueurs (26 cartes chacun)
2. À chaque tour, chaque joueur retourne sa carte du dessus
3. La carte la plus haute gagne le tour (+1 point au gagnant)
4. En cas d'égalité de valeur: "War!"
   - Chaque joueur pose 3 cartes face cachée (non comparées, juste défaussées)
   - Puis chaque joueur pose une 4ème carte face visible
   - Ces 4èmes cartes sont comparées pour déterminer le gagnant du War
   - En cas de nouvelle égalité sur les 4èmes cartes, répéter le processus (3 cachées + 1 visible)
   - Si un joueur n'a pas assez de cartes pour War, l'autre joueur gagne automatiquement
5. Le jeu continue jusqu'à ce qu'un joueur n'ait plus de cartes
6. Le joueur avec le plus de points gagne

## Architecture du système

### 1. Enums (1 point)

**Enum Suit** - Représente les couleurs des cartes.

```swift
enum Suit: String, CaseIterable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"
}
```

**Enum Rank** - Représente les valeurs des cartes. Doit être comparable pour déterminer la carte gagnante.

```swift
enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace

    // Computed property pour affichage
    var name: String {
        // TODO: Retourner "2", "3", ..., "10", "Jack", "Queen", "King", "Ace"
    }

    // Implémenter Comparable
    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
```

### 2. Struct Card (2 points)

Représente une carte avec sa couleur et sa valeur.

**Requis:**
- Properties: `rank: Rank`, `suit: Suit`
- Conformité à `Comparable` (compare par rank uniquement)
- Computed property `description: String` retournant "Ace of ♠" par exemple

### 3. Class Deck (3 points)

Représente un paquet de 52 cartes.

**Requis:**
- Property: `cards: [Card]`
- Initializer qui génère les 52 cartes (13 ranks × 4 suits)
- Method `shuffle()`: mélange les cartes
- Method `draw() -> Card?`: tire une carte (retourne nil si vide)
- Method `reset()`: recrée et mélange un nouveau deck complet

### 4. Protocol Player (2 points)

Définit le comportement d'un joueur.

**Requis:**
- Protocol doit hériter de `AnyObject` (class-only protocol)
- Property `name: String { get }`
- Property `hand: [Card] { get set }`
- Property `score: Int { get set }`
- Method `playCard() -> Card?`: joue la première carte de la main
- Method `receiveCard(_ card: Card)`: ajoute une carte à la main

```swift
protocol Player: AnyObject {
    // ...
}
```

### 5. Classes de joueurs (2 points)

**HumanPlayer:**
- Conforme au protocol Player
- Implémente toutes les méthodes requises

**AIPlayer:**
- Conforme au protocol Player
- Comportement identique à HumanPlayer (joue simplement la première carte)

### 6. Class Game (7 points)

Gère la logique du jeu.

**Requis:**
- Properties: `player1: Player`, `player2: Player`, `deck: Deck`
- Method `dealCards()`: distribue toutes les cartes équitablement
- Method `playRound()`: joue un tour complet et **implémente la logique War! complète** (3 cartes face cachée + 4ème carte, gérer les égalités répétées)
- Method `play()`: lance la partie complète et affiche le résultat

### 7. Extensions (2 points)

Créer une extension pour `Array<Card>` avec les fonctionnalités suivantes :

**Requis:**
- Method `highest() -> Card?` : retourne la carte la plus haute du tableau (ou nil si vide)
- Computed property `description: String` : retourne une représentation textuelle formatée du tableau de cartes

```swift
extension Array where Element == Card {
    func highest() -> Card? {
        // TODO: Retourner la carte avec le rank le plus élevé
    }

    var description: String {
        // TODO: Retourner "Ace of ♠️, 5 of ♥️, King of ♦️" par exemple
    }
}
```

### 8. Simulation de partie (1 point)

Lancer une partie complète avec affichage des résultats.

**Note technique :** Le code utilise `CardGameManager` comme point d'entrée pour éviter du code top-level (interdit en Swift). Votre implémentation doit se faire dans la méthode `run()` :

```swift
func run() {
    print("Card Game: War")
    print("=================\n")

    let player1 = HumanPlayer(name: "Alice")
    let player2 = AIPlayer(name: "Bob")

    let game = Game(player1: player1, player2: player2)
    game.play()
}
```

## Exemple de sortie attendue

```
Card Game: War
=================

Dealing cards...
Maurane received 26 cards
Bob received 26 cards

--- Round 1 ---
Maurane plays: 7 of ♥
Bob plays: Queen of ♠
Bob wins this round!
Score: Maurane 0 - Bob 1

--- Round 2 ---
Maurane plays: Ace of ♦
Bob plays: King of ♣
Maurane wins this round!
Score: Maurane 1 - Bob 1

--- Round 3 ---
Maurane plays: 5 of ♥
Bob plays: 5 of ♠
War! Each player plays 3 cards...
Maurane plays: Jack of ♦
Bob plays: 9 of ♣
Maurane wins the war!
Score: Maurane 2 - Bob 1

...

=== GAME OVER ===
Winner: Bob with 28 points!
Final score: Maurane 24 - Bob 28
```

## Méthode de travail

1. Compléter les `TODO` dans l'ordre (1 à 8)
2. Tester régulièrement avec `swift run`
3. Commencer simple, puis ajouter de la complexité

## Conseils

1. Commencez par créer et tester les enums (Suit, Rank)
2. Créez la struct Card et vérifiez la comparaison
3. Implémentez le Deck et testez shuffle/draw
4. Créez HumanPlayer avant de vous préoccuper de AIPlayer
5. Implémentez Game progressivement (d'abord sans gérer War!)
6. Ajoutez la logique War! en dernier

## Critères d'évaluation

| Critère | Points |
|---------|--------|
| Implémentation | 14 pts |
| Protocols & Extensions | 4 pts |
| Enums & Simulation | 2 pts |
| **Total** | **20 pts** |

**Implémentation (14 pts):**
- Struct Card (2 pts) : Comparable + description
- Class Deck (3 pts) : Génération 52 cartes, shuffle, draw, reset
- Classes Players (2 pts) : HumanPlayer et AIPlayer conformes au protocol
- Class Game (7 pts) : dealCards, playRound avec War!, play complet

**Protocols & Extensions (4 pts):**
- Protocol Player (2 pts) : Bien défini avec toutes les properties/methods requises
- Extensions (2 pts) : Extension utile sur Array<Card>

**Enums & Simulation (2 pts):**
- Enums (1 pt) : Suit et Rank fournis, vérifier compréhension
- Simulation (1 pt) : main.swift lance une partie complète
