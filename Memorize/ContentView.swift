//
//  ContentView.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 19/02/2021.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        let hstack = HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(.orange)

        if viewModel.cardCount == 5 {
            print("font to title")
            return hstack.font(Font.title)
        } else {
            print("font to largeTitle")
            return hstack.font(Font.largeTitle)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body:some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10).stroke()
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10).fill()
            }
        }
        .aspectRatio(2 / 3, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
