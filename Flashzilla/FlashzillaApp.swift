//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftUI
import SwiftData

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Card.self)
        }
    }
}
