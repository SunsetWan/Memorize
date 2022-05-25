//
//  ContentView.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/18.
//

import SwiftUI

/// What's the diff between transition and animation?

/// Animation:
/// `Shape`s is animatable
/// `ViewModifier`s is animatable too!
/// 1. Only changes can be animated
/// Animation is showing the user changes that have already happened (i.e. the recent past)
/// `ViewModifier` are the primary "change agents" in the UI.
/// A change to a `ViewModifier`'s arguments has to happen **after** the View is initially put in the UI.
/// In other words, only changes in a `ViewModifier`'s arguments **since it joined the UI** are animated.
/// Not all `ViewModifier` arguments are animatable (e.g. .font's are not), but most are.
/// When a View arrives or departs, the **entire thing** is animated as a unit.
///
/// 2. A View coming **on-screen** is only animated if it's **joining a container that is already in the UI**.
/// 3. A View going **off-screen** is only animated if it's **leaving a container that is staying in the UI**.
/// `ForEach` and `if-else` in ViewBuilders are common ways to make Views come and go.
///
/// The .animation modifier does not work how you might think on a **container**.
/// A container just **propagates** the .animation modifier to all the views it contains.

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
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    var gameBody: some View {
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
        .onAppear { // It's a great way to not put a View on screen until afer its container appears.
            // "deal" cards
            withAnimation {
                for card in game.cards {
                    deal(card)
                }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
//            ForEach(game.cards.filter({ isUndealt($0)})) { card in
            ForEach(game.cards.filter(isUndealt(_:))) { card in
                CardView(card)
            }
        }
        .frame(width: 60, height: 90)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2 / 3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation { // This is the explicit animation.
                game.shuffle()
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            gameBody
            shuffleButton
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
//            Rectangle().opacity(0)
            Color.clear // Colors that can be used as a View, another example is `Path`
        } else {
            CardView(card)
                .padding(4)
//                .transition(AnyTransition.scale.animation(Animation.easeInOut))
                .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity).animation(.easeInOut(duration: 1)))
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
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
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                
                /// NOTE: This is the implicit animation modifier
                    .animation(Animation.easeInOut(duration: 2).repeatCount(2, autoreverses: false), value: card.isMatched)
                
                /// NOTE: .font modifier that is varying the size of the font
                /// And font is a ViewModifier that is not animatable.
                //                    .font(font(in: geometry.size))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            //            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        
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
