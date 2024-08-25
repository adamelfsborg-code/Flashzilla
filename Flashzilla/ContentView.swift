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
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    
    @State private var deck = Array<Card>(repeating: .example, count: 10)
    @State private var timeRemaning = 100
    @State private var isActive = true
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaning)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
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
                .allowsHitTesting(timeRemaning > 0)
                
                if deck.isEmpty {
                    Button("Start again", action: resetDeck)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(.capsule)
                }
            }
            if accessibilityDifferentiateWithoutColor {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            guard timeRemaning > 0 else { return }
            
            timeRemaning -= 1
        }
        .onChange(of: scenePhase) {
            guard deck.isEmpty == false else { return }
            isActive = scenePhase == .active
        }
    }
    
    func removeCard(at index: Int) {
        deck.remove(at: index)
        
        isActive = deck.isEmpty == false
    }
    
    func resetDeck() {
        deck = Array<Card>(repeating: .example, count: 10)
        timeRemaning = 100
        isActive = true
    }
}

#Preview {
    ContentView()
}
