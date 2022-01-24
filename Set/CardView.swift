//
//  CardView.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

typealias Feature = Set.Feature

struct CardView: View {
    let card: Set.Card
    
    init(card: Set.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if card.isMatched {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .stroke(lineWidth: computeStrokeWidth(size: geo.size))
                        .foregroundColor(.green)
                } else if let _ = card.failedMatch {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .stroke(lineWidth: computeStrokeWidth(size: geo.size))
                        .foregroundColor(.red)
                } else if card.selected {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .stroke(lineWidth: computeStrokeWidth(size: geo.size))
                        .foregroundColor(.blue)
                } else {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .stroke()
                }
                CardContent(card: card)
                    .aspectRatio(1.5/2, contentMode: .fit)
                    .padding()
            }
        }
    }
    
    func computeStrokeWidth(size: CGSize) -> CGFloat {
        return min(size.width, size.height) * DrawingConstants.stroke
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 0.8
        static let stroke: CGFloat = 0.05
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Set.Card(symbol: Feature.A, fill: Feature.A, number: Feature.A, color: Feature.A)
        CardView(card: card)
    }
}
