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
    
    private static let emojis = ["😤", "😠", "😡", "🤬", "😱",
                  "🤯", "😳", "🥵", "🥶", "😶‍🌫️",
                  "😨", "😰", "😥", "😓", "🤗",
                  "🫡", "🫢", "🫣", "🤭", "🤔",
                  "👺", "🤡", "💩", "👻", "💀",
                  "☠️", "👽", "👾", "🤖", "🎃"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in
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
}
