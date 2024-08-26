//
//  EditCards.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-25.
//

import SwiftUI
import SwiftData

struct EditDeck: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query var deck: [Card]
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<deck.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(deck[index].prompt)
                                .font(.headline)
                            Text(deck[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Deck")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }
    
    func done() {
        dismiss()
    }

    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        modelContext.insert(card)
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        for offset in offsets {
            let card = deck[offset]
            modelContext.delete(card)
        }
    }
}

#Preview {
    EditDeck()
}
