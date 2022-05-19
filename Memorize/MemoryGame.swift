//
//  MemoryGame.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/19.
//

import Foundation



struct MemoryGame<CardContent: Hashable> {
    struct Card: Identifiable {
        static func == (lhs: MemoryGame<CardContent>.Card, rhs: MemoryGame<CardContent>.Card) -> Bool {
            (lhs.id == rhs.id) && (lhs.content == lhs.content)
        }
        
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
    private(set) var cards: [Card]
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0 == card }) {
            cards[chosenIndex].isFaceUp.toggle()
            print("chosen card:" + String(describing: cards[chosenIndex]))
            print("all cards:\n" + String(describing: cards))
        } else {
            fatalError()
        }
    }
}
