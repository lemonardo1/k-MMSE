//
//  GameResult.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import Foundation
import SwiftData

@Model
final class GameResult {
    var gameType: String
    var score: Int
    var timestamp: Date
    
    init(gameType: String, score: Int, timestamp: Date = Date()) {
        self.gameType = gameType
        self.score = score
        self.timestamp = timestamp
    }
}
