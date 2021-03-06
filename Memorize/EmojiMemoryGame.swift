//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/19.
//

import SwiftUI

/// View Model
/// What is `ObservableObject`?
class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["π€", "π ", "π‘", "π€¬", "π±",
                  "π€―", "π³", "π₯΅", "π₯Ά", "πΆβπ«οΈ",
                  "π¨", "π°", "π₯", "π", "π€",
                  "π«‘", "π«’", "π«£", "π€­", "π€",
                  "πΊ", "π€‘", "π©", "π»", "π",
                  "β οΈ", "π½", "πΎ", "π€", "π"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 12) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    /// MVVM Notification
    ///
    /// `@Published` help us automatically do objectWillChange.send()
    @Published private(set) var model = createMemoryGame()
    
    var cards: [Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        /// IMPORTANT:
        objectWillChange.send()
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
