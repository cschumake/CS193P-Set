//
//  CardContent.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

struct CardContent: View {
    let card: Set.Card
    typealias Feature = Set.Feature
    
    init(card: Set.Card) {
        self.card = card
    }
    
    func getNumber(_ feature: Set.Feature) -> Int {
        switch feature {
        case Feature.A:
            return 1
        case Feature.B:
            return 2
        case Feature.C:
            return 3
        }
    }
    
    func getColor(_ feature: Set.Feature) -> Color {
        switch feature {
        case Feature.A:
            return .green
        case Feature.B:
            return .blue
        case Feature.C:
            return .red
        }
    }
    
    func renderFilling<ContentView: Shape>(@ViewBuilder for content: () -> ContentView) -> some View {
        ZStack {
            switch card.fill {
            case Feature.A:
                content().foregroundColor(getColor(card.color))
            case Feature.B:
                content().foregroundColor(.white)
            case Feature.C:
                content()
                    .foregroundColor(getColor(card.color))
                    .opacity(0.4)
            }
            content().stroke(getColor(card.color), lineWidth: 1.3)
        }
    }
    
    @ViewBuilder func renderShape(card: Set.Card) -> some View {
        Group {
            switch card.symbol {
            case Feature.A: renderFilling() { Circle() }
            case Feature.B: renderFilling() { Capsule() }
            case Feature.C: renderFilling() { Dimond() }
            }
        }
    }
    
    var body: some View {
        HStack {
            ForEach(0..<getNumber(card.number), id: \.self) { _ in
                renderShape(card: card)
            }
        }
    }
}

struct CardContent_Previews: PreviewProvider {
    static var previews: some View {
        let card = Set.Card(symbol: Feature.A, fill: Feature.A, number: Feature.A, color: Feature.A)
        CardView(card: card)
    }
}
