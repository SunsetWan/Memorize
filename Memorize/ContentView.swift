//
//  ContentView.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/18.
//

import SwiftUI

struct ContentView: View {
//    var emojis = ["😤", "😤", "😠", "😡", "🤬"]
    var emojis = ["😤", "😠", "😡", "🤬", "😱",
                  "🤯", "😳", "🥵", "🥶", "😶‍🌫️",
                  "😨", "😰", "😥", "😓", "🤗",
                  "🫡", "🫢", "🫣", "🤭", "🤔",
                  "👺", "🤡", "💩", "👻", "💀",
                  "☠️", "👽", "👾", "🤖", "🎃"]
    
    @State var emojiCount = 7
    
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
                    ForEach(emojis[..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2 / 3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            .padding(.horizontal)
            .font(.largeTitle)
        }
        .padding(.horizontal)
        
    }
}

struct CardView: View {
    /// @State make `isFaceUp` a pointer to some Boolean value in memory
    @State var isFaceUp: Bool = true
    
    var content: String = "🫥"
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
            
//            print(isFaceUp)
        }
    }
}



















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
