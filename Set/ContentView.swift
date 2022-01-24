//
//  ContentView.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game = SetViewModel()
    var body: some View {
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 2/3, minimumWidth: 65.0) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        game.selectCard(card: card)
                    }
            }
            HStack {
                Button(action: { game.newGame() }) {
                    Text("New Game")
                }
                Spacer()
                Button(action: { _ = game.draw() }) {
                    Text("Draw cards")
                }
                .disabled(game.cards.isEmpty)
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
