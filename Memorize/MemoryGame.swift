//
//  MemoryGame.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 20/02/2021.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            // except all cards face down except the one we just chose
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // since structs are immutable by default
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // to unwrap optional
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    if lastFaceUpdate == nil {
                        lastFaceUpdate = Date()
                    }
                } else {
                    pastFaceUpTime = faceUpTime
                    lastFaceUpdate = nil
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                pastFaceUpTime = faceUpTime
                lastFaceUpdate = nil
            }
        }
        var content: CardContent
        var id: Int
        
        var bounsTimeLimit: TimeInterval = 6
        var bounsTimeRemaining: TimeInterval {
            max(0, bounsTimeLimit - faceUpTime)
        }
        var bounsRemaining: Double {
            (bounsTimeLimit > 0 && bounsTimeRemaining > 0) ? bounsTimeRemaining/bounsTimeLimit : 0
        }
        
        var isConsumingBounsTime: Bool {
            isFaceUp && !isMatched && bounsTimeRemaining > 0
        }
        
        var lastFaceUpdate: Date?
        var pastFaceUpTime: TimeInterval = 0
        var faceUpTime: TimeInterval {
            if let lastFaceUpdate = self.lastFaceUpdate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpdate)
            } else {
                return pastFaceUpTime
            }
        }
    }
}
