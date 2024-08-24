//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @State private var deck = Array<Card>(repeating: .example, count: 10)
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                ZStack {
                    ForEach(0..<deck.count, id: \.self) { index in
                        CardView(card: deck[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: deck.count)
                    }
                }
            }
        }
    }
    
    func removeCard(at index: Int) {
        deck.remove(at: index)
    }
}

#Preview {
    ContentView()
}
