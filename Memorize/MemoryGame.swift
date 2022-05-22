//
//  MemoryGame.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/19.
//

import Foundation

/// What's the difference?
//struct MemoryGame<CardContent: Hashable> {
struct MemoryGame<CardContent> where CardContent: Hashable {
    struct Card: Identifiable {
        static func == (lhs: MemoryGame<CardContent>.Card, rhs: MemoryGame<CardContent>.Card) -> Bool {
            (lhs.id == rhs.id) && (lhs.content == lhs.content)
        }
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0 == card }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let indexOfTheOneAndOnlyFaceUpCard = indexOfTheOneAndOnlyFaceUpCard {
                if cards[indexOfTheOneAndOnlyFaceUpCard].content == cards[chosenIndex].content {
                    cards[indexOfTheOneAndOnlyFaceUpCard].isMatched = true
                    cards[chosenIndex].isMatched = true
                }
                self.indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                self.indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            
            
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
}
