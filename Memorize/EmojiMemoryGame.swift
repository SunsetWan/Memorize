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
    static let emojis = ["😤", "😠", "😡", "🤬", "😱",
                  "🤯", "😳", "🥵", "🥶", "😶‍🌫️",
                  "😨", "😰", "😥", "😓", "🤗",
                  "🫡", "🫢", "🫣", "🤭", "🤔",
                  "👺", "🤡", "💩", "👻", "💀",
                  "☠️", "👽", "👾", "🤖", "🎃"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 3) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    /// MVVM Notification
    ///
    /// `@Published` help us automatically do objectWillChange.send()
    @Published private(set) var model = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        /// IMPORTANT:
        objectWillChange.send()
        model.choose(card)
    }
}
