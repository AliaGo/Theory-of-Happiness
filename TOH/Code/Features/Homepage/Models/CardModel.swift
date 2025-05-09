//
//  CastleQA.swift
//  TOH
//
//  Created by Alia on 2025/3/2.
//

import Foundation
import SwiftUI

struct Card: Hashable, Identifiable, Codable {
    var id : Int
    var type: String?
    var topic: String?
    var question: String
    var answer: String
    var description: String?
    var url: String?
    
}

struct CastleQA: Hashable, Identifiable, Codable {
    var id : Int
    var question: String
    var answer: String
    var description: String
}

enum CardType: String, CaseIterable, Identifiable {
    case castleQA = "castleQA"
    case castleKnowledge = "castleKnowledge"
    case ramenKnowledge = "ramenKnowledge"

    var id: String { self.rawValue }
}
