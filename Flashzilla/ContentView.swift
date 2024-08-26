//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI
import SwiftData

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Card.timestamp, order: .reverse) var deck: [Card]
    @State private var timeRemaning = 100
    @State private var isActive = true
    @State private var isShowingEditScreen = false
    
    @State private var isAnswerWrong = false
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
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
                    ForEach(deck) { card in
                        let index = deck.firstIndex(where: {$0.id == card.id }) ?? -1
                        
                        CardView(card: card) { isAnswerWrong in
                            withAnimation {
                                self.isAnswerWrong = isAnswerWrong
                                self.removeCard(card: card)
                            }
                        }
                        .stacked(at: index, in: self.deck.count)
                        .allowsHitTesting(index == self.deck.count - 1)
                        .accessibility(hidden: index < self.deck.count - 1)
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
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                       isShowingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor  || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(card: deck.last!)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(card: deck.last!)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark yuour answer as being correct.")
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
            guard !deck.isEmpty else { return }
            isActive = scenePhase == .active
        }
        .sheet(isPresented: $isShowingEditScreen, onDismiss: resetDeck, content: EditDeck.init)
        .onAppear(perform: resetDeck)
        
    }
    
    func removeCard(card: Card) {
        modelContext.delete(card)
        
        if isAnswerWrong {
            let tempCard = Card(prompt: card.prompt, answer: card.answer)
            modelContext.insert(tempCard)
            
            isAnswerWrong = false
        }
        
        try? modelContext.save()
        isActive = !deck.isEmpty
    }
    
    func resetDeck() {
        guard !deck.isEmpty else { return }
        timeRemaning = 100
        isActive = true
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Card.self, configurations: config)
        
        for _ in 0...10 {
            let card = Card.example
            container.mainContext.insert(card)
        }
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to preview \(error.localizedDescription)")
    }
}
