//
//  Grid.swift
//  Memorize
//
//  Created by Ghasem Elyasi on 22/02/2021.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        return ForEach(items) { item in
            let index = items.firstIndex(matching: item)
            
            Group {
                if index != nil {
                    viewForItem(item)
                        .frame(width: layout.itemSize.width, height: layout.itemSize.height) // set size of view
                        .position(layout.location(ofItemAt: index!)) // set position of view on screen
                }
            }
        }
    }
}
