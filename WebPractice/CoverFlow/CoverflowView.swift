//
//  CoverflowView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct CoverflowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    
    var itemWidth: CGFloat
    var spacing: CGFloat = 0
    var items: Item
    var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) {
                        item in content(item)
                            .frame(width: itemWidth)
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal, (size.width - itemWidth)/2)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}

struct CoverflowItem: Identifiable {
    let id: UUID = .init()
    var title: String
    var color: Color
}

#Preview {
    ContentView()
}
