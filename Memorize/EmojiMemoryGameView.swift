//
//  ContentView.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/18.
//

import SwiftUI

/// Animation:
/// `Shape`s is animatable
/// `ViewModifier`s is animatable too!
/// Only changes can be animated
/// Animation is showing the user changes that have already happened (i.e. the recent past)
/// `ViewModifier` are the primary "change agents" in the UI.
/// A change to a `ViewModifier`'s arguments has to happen **after** the View is initially put in the UI.
/// In other words, only changes in a `ViewModifier`'s arguments **since it joined the UI** are animated.
/// Not all `ViewModifier` arguments are animatable (e.g. .font's are not), but most are.
/// When a View arrives or departs, the **entire thing** is animated as a unit.
///
/// A View coming **on-screen** is only animated if it's **joining a container that is already in the UI**.
/// A View going **off-screen** is only animated if it's **leaving a container that is staying in the UI**.
/// `ForEach` and `if-else` in ViewBuilders are common ways to make Views come and go.

/// `ViewModifier`:
/// `ViewModifier`s actually are Views!

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
//            ScrollView {
//                /// A LazyVGrid has a different strategy.
//                /// It uses all the width horizontally for its columns,
//                /// But vertically it's going to make the cards as small as possible,
//                /// So it can fit as many as possible.
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
//                    /// What is `id` parameter used for?
//                    /// Elements must be identifiable,
//                    /// so that the ForEach can keep track of which things in the array
//                    /// which of the Views it's creating.
//                    /// It normally does this by requiring the things in the array
//                    /// to behave like an identifiable.
//                    ///
//                    /// Generic struct 'ForEach' requires that 'MemoryGame<String>.Card' conform to 'Hashable'
//                    ForEach(game.cards, id: \.id) { card in
//                        CardView(card)
//                            .aspectRatio(2 / 3, contentMode: .fit)
//                            .onTapGesture {
//                                game.choose(card)
//                            }
//                    }
//                }
//            }
//            .foregroundColor(.red)
//            .padding()
            
            AspectVGrid(items: game.cards, aspectRatio: 2 / 3) { card in
                cardView(for: card)
            }
            .foregroundColor(.red)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0 - 90),
                    endAngle: Angle(degrees: 110 - 90))
                .padding(5).opacity(0.5)
                Text(card.content).font(font(in: geometry.size))
            }
//            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        
        private init() {}
    }
}


















































/// can act as testing bed
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        let firstCard = game.cards.first!
        game.choose(firstCard)
        return EmojiMemoryGameView(game: game)
    }
}
