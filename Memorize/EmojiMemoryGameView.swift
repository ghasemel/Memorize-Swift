//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 19/02/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(.orange)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: {
                Text("New Game")
            })
        }
    }
    //.edgesIgnoringSafeArea(.top)
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    
    var body:some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animationBounsRemaining: Double = 0
    private func startBounsTimeRemaining() {
        animationBounsRemaining = card.bounsRemaining
        withAnimation(.linear(duration: card.bounsTimeRemaining)) {
            animationBounsRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBounsTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animationBounsRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBounsTimeRemaining()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bounsRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
   
        }
    }
    
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.7
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
