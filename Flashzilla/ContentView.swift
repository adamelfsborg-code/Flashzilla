//
//  ContentView.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var body: some View {
        VStack {
            Text("Hello world")
                .onReceive(timer, perform: { time in
                    if counter == 5 {
                        cancelTimer()
                    } else {
                        print("The time is not \(time)")
                    }
                    
                    counter += 1
                })
        }
    }
    
    func cancelTimer() {
        timer.upstream.connect().cancel()
    }
}

#Preview {
    ContentView()
}
