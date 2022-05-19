//
//  MemoryGame.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/19.
//

import Foundation



struct MemoryGame<CardContent> {
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
    
    private(set) var cards: [Card]
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
}
