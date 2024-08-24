//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    }
    return try withAnimation(animation, body)
}

struct ContentView: View {
    @State private var scale = 1.0
    
    var body: some View {
        Button("Hello world") {
            withOptionalAnimation {
                scale *= 1.5
            }
        }
        .scaleEffect(scale)
    }
}

#Preview {
    ContentView()
}
