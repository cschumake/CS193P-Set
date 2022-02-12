//
//  SetViewController.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

class SetViewModel: ObservableObject {
    @Published private var model = SetModel()
    
    var cards: [SetModel.Card] {
        return model.cards
    }
    
    var discardedCards: [SetModel.Card] {
        return model.discardedCards
    }
    
    var deck: [SetModel.Card] {
        return model.deck
    }
    
    func draw() -> [SetModel.Card] {
        return model.drawThreeCards()
    }
    
    // Mark - Intent(s)
    func selectCard(card: SetModel.Card) {
        model.selectCard(card: card)
    }
    
    func newGame() {
        model = SetModel()
    }
}
