//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 19/02/2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiMemoryGame()
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
