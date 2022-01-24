//
//  SetViewController.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

class SetViewModel: ObservableObject {
    @Published private var model = Set()
    
    var cards: [Set.Card] {
        return model.cards
    }
    
    func draw() -> [Set.Card] {
        return model.drawThreeCards()
    }
    
    // Mark - Intent(s)
    func selectCard(card: Set.Card) {
        model.selectCard(card: card)
    }
    
    func newGame() {
        model = Set()
    }
}
