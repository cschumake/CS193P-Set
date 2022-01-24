//
//  Model.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import Foundation

struct Set {
    private var deck: [Card]
    typealias Feature = Card.Feature
    private var cardsInPlay: [Card]
    
    mutating func selectCard(card: Card) {
        updateSelectedStatus(card: card)
        let selectedCards = selectedCards()
        
        if selectedCards.count == 3 {
            if selectedCards.isSet() {
                for card in selectedCards {
                    updateMatchedStatus(card: card)
                }
            } else {
                for card in selectedCards {
                    updateFailedMatchedStatus(card: card)
                }
            }
        } else if selectedCards.count > 3 {
            if selectedCards.filter({ $0.id != card.id }).allSatisfy({ $0.isMatched == true }) {
                for card in selectedCards.filter({ $0.id != card.id }) {
                    cardsInPlay.removeAll(where: { $0.id == card.id })
                }
                _ = drawThreeCards()
            }
            for (index, _) in cardsInPlay.enumerated() {
                cardsInPlay[index].selected = false
                cardsInPlay[index].failedMatch = nil
            }
            updateSelectedStatus(card: card)
        }
    }
    
    func selectedCards() -> [Card] {
        return cardsInPlay.filter({ $0.selected })
    }
    
    mutating private func updateSelectedStatus(card: Card) {
        if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            cardsInPlay[index].selected.toggle()
        }
    }
    
    mutating private func updateMatchedStatus(card: Card) {
        if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            cardsInPlay[index].isMatched.toggle()
        }
    }
    
    mutating private func updateFailedMatchedStatus(card: Card) {
        if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            if let _ = cardsInPlay[index].failedMatch {
                cardsInPlay[index].failedMatch = nil
            } else {
                cardsInPlay[index].failedMatch = true
            }
        }
    }
    
    init() {
        deck = []
        cardsInPlay = []
        
        func addThreeCardsToDeck(symbol: Feature, number: Feature, color: Feature) {
            for feature in Feature.allCases {
                let newCard = Card(symbol: symbol, fill: feature, number: number, color: color)
                deck.append(newCard)
            }
        }
        
        // Build all cards with Feature A as their number
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.A, number: Feature.A, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.B, number: Feature.A, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.C, number: Feature.A, color: color)
        }
        
        // Build all cards with Feature B as their number
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.A, number: Feature.B, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.B, number: Feature.B, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.C, number: Feature.B, color: color)
        }
        
        // Build all cards with Feature C as their number
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.A, number: Feature.C, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.B, number: Feature.C, color: color)
        }
        for color in Feature.allCases {
            addThreeCardsToDeck(symbol: Feature.C, number: Feature.C, color: color)
        }
        
        deck.shuffle()
        _ = initialDraw()
    }
    
    private mutating func initialDraw() -> [Card] {
        return drawCards(numberOfCards: 12)
    }
    
    mutating func drawThreeCards() -> [Card] {
        if selectedCards().isSet() {
            for card in selectedCards() {
                cardsInPlay.removeAll(where: { $0.id == card.id })
            }
            return drawThreeCards()
        }
        return drawCards(numberOfCards: 3)
    }
    
    private mutating func drawCards(numberOfCards: Int) -> [Card] {
        for _ in 0..<numberOfCards {
            if let card = deck.popLast() {
                cardsInPlay.append(card)
            }
        }
        return cardsInPlay
    }
    
    var cards: [Card] {
        return cardsInPlay
    }
    
    struct Card: Identifiable {
        let id = UUID()
        
        enum Feature: CaseIterable {
            case A
            case B
            case C
        }
        
        var selected = false
        var isMatched = false
        var failedMatch: Bool?
        let symbol: Feature
        let fill: Feature
        let number: Feature
        let color: Feature
    }
}

extension Array where Element == Set.Card {
    func isSet() -> Bool {
        if self.count != 3 {
            return false
        }
        
        let color = self[0].color == self[1].color && self[0].color == self[2].color ||
        self[0].color != self[1].color && self[0].color != self[2].color && self[1].color != self[2].color
        
        let number = self[0].number == self[1].number && self[0].number == self[2].number ||
        self[0].number != self[1].number && self[0].number != self[2].number && self[1].number != self[2].number
        
        let symbol = self[0].symbol == self[1].symbol && self[0].symbol == self[2].symbol ||
        self[0].symbol != self[1].symbol && self[0].symbol != self[2].symbol && self[1].symbol != self[2].symbol
        
        let fill = self[0].fill == self[1].fill && self[0].fill == self[2].fill ||
        self[0].fill != self[1].fill && self[0].fill != self[2].fill && self[1].fill != self[2].fill
        
        return color && number && symbol && fill
    }
}
