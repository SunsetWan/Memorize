//
//  MemorizeApp.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
