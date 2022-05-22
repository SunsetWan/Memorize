//
//  ContentView.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/18.
//

import SwiftUI

/// Keyword: `@State`:
/// Changes to this @State var will cause your View to rebuild its body
/// It's sort of like an @ObservedObject but on a random piece of data instead of a ViewModel
/// This is actually going to make some space **in the heap** for this.
/// When your read-only Views gets rebuilt, the new version will continue to point to it.
/// In other words, changes to your View(via its arguments) will not dump this state.
/// Use `@State` sparingly!

struct EmojiMemoryGameView: View {
    /// `@ObservedObject` means that when viewModel did change,
    /// please rebuild my entire body
    ///
    /// Property wrapper can only be applied to a 'var'
    /// It's the viewModel.
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                /// A LazyVGrid has a different strategy.
                /// It uses all the width horizontally for its columns,
                /// But vertically it's going to make the cards as small as possible,
                /// So it can fit as many as possible.
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    /// What is `id` parameter used for?
                    /// Elements must be identifiable,
                    /// so that the ForEach can keep track of which things in the array
                    /// which of the Views it's creating.
                    /// It normally does this by requiring the things in the array
                    /// to behave like an identifiable.
                    ///
                    /// Generic struct 'ForEach' requires that 'MemoryGame<String>.Card' conform to 'Hashable'
                    ForEach(game.cards, id: \.id) { card in
                        CardView(card)
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
            .font(.largeTitle)
            .padding()
        }
    }
}

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}



















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
