//
//  ContentView.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game = SetViewModel()
    @Namespace private var dealingNamespace
    @Namespace private var discardedNamespace
    
    var body: some View {
        VStack {
            gameBody
            HStack {
                remainingCards
                Spacer()
                discardedCards
            }
        }
        .padding()
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, minimumWidth: 65.0) { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: discardedNamespace)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .aspectRatio(2/3, contentMode: .fit)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        game.selectCard(card: card)
                    }
                }
        }
    }
    
    var remainingCards: some View {
        VStack {
            ZStack {
                ForEach(game.deck) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                        .overlay(.gray)
                }
            }
            .onTapGesture {
                withAnimation {
                    _ = game.draw()
                }
            }
            .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            .border(.black, width: CardConstants.borderWidth)
            Text("Deck")
        }

    }
    
    var discardedCards: some View {
        VStack {
            ZStack {
                if let card = game.discardedCards.last {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: discardedNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .slide, removal: .identity))
                }
            }
            .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            .border(.black, width: CardConstants.borderWidth)
            Text("Discarded")
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let borderWidth: CGFloat = 2.0
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
