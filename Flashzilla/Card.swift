//
//  Card.swift
//  Flashzilla
//
//  Created by Adam Elfsborg on 2024-08-24.
//

import SwiftData
import Foundation

@Model
class Card {
    var prompt: String
    var answer: String
    var timestamp: Date = Date.now
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who ?", answer: "Jodie Withttaker")
    
    init(prompt: String, answer: String) {
        self.prompt = prompt
        self.answer = answer
    }
}
