//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero
    
    var body: some View {
        Text("Rotate")
            .rotationEffect(finalAmount + currentAmount)
            .gesture(
               RotateGesture()
                .onChanged { value in
                    currentAmount = value.rotation
                }
                .onEnded { value in
                    finalAmount += currentAmount
                    currentAmount = .zero
                }
            )
    }
}

#Preview {
    ContentView()
}
