//
//  Cardify.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/23.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    internal init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degress
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
//            if isFaceUp {
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            
            /// `content` is animatable afer it's in UI!!!
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
//        .rotation3DEffect(.degrees(isFaceUp ? 0 : 180), axis: (0, 1, 0))
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        
        private init() {}
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
