//
//  AspectVGrid.swift
//  Set
//
//  Created by Caleb Schumake on 1/22/22.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    let minimumWidth: CGFloat
    
    init(items: [Item], aspectRatio: CGFloat, minimumWidth: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
        self.minimumWidth = minimumWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)]) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                
                // Geometry reader takes up all space given to it. The lazy v grid does not,
                // lets add a Spacer to make sure we are using all the space.
                //Spacer(minLength: 0)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        let width = floor(size.width / CGFloat(columnCount))
        return width < minimumWidth ? minimumWidth : width
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}

