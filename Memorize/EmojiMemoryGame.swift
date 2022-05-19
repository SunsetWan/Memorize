//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/19.
//

import SwiftUI

/// View Model
class EmojiMemoryGame {
    static let emojis = ["😤", "😠", "😡", "🤬", "😱",
                  "🤯", "😳", "🥵", "🥶", "😶‍🌫️",
                  "😨", "😰", "😥", "😓", "🤗",
                  "🫡", "🫢", "🫣", "🤭", "🤔",
                  "👺", "🤡", "💩", "👻", "💀",
                  "☠️", "👽", "👾", "🤖", "🎃"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    private(set) var model = createMemoryGame()
}
