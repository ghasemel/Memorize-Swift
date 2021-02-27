//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 20/02/2021.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(pairCount: Int.random(in: 2...5))
    
    private static func createMemoryGame(pairCount: Int) -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷", "💀", "😱", "😈", "👺", "👽", "🤖", "👹", "🤡", "👾"]
        print("cardCount: \(pairCount)")
        
        return MemoryGame<String>(numberOfPairsOfCards: pairCount) { pairIndex in
            let emojiIndex = Int.random(in: 0..<emojis.count)
            return emojis[emojiIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var cardCount: Int {
        model.cards.count / 2
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame(pairCount: Int.random(in: 2...5))
    }
}
