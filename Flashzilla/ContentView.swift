//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    var body: some View {
        Text("Double tap")
            .onTapGesture(count: 2) {
                print("Double tap")
            }
        
        Text("Long press")
            .onLongPressGesture {
                print("Long Press")
            }
        Text("2 sek press")
            .onLongPressGesture(minimumDuration: 2) {
                print("2 sek press")
            } onPressingChanged: { inProgress in
                print("In progress: \(inProgress)")
            }
        
        Text("Scale")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}

#Preview {
    ContentView()
}
