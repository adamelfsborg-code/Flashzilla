//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    
    var body: some View {
        Text("Hello wolrd")
            .padding()
            .background(accessibilityReduceTransparency ? .black : .black.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(.capsule)
    }
}

#Preview {
    ContentView()
}
