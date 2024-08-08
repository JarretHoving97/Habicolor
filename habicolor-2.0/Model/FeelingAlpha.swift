//
//  FeelingAlpha.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import Foundation

/// used for color calculatiion to determine the opacity
/// for any color
enum FeelingAlpha: Double {
    case low = 0.2
    case mediumLow = 0.4
    case medium = 0.6
    case mediumHigh = 0.8
    case high = 1.0
}


extension FeelingAlpha {

    // converts a emoji to alpha color
    static func from(emoji: Emoji) -> FeelingAlpha {
        switch emoji {
        case .terrible:
            return .low
        case .hard:
            return .mediumLow
        case .neutral:
            return .medium
        case .happy:
            return .mediumHigh
        case .great:
            return .high
        }
    }
}


extension Double {
    
    /// get alpha for the emoji score.
    static func alpha(for emoji: Emoji) -> Double {
        return FeelingAlpha.from(emoji: emoji).rawValue
    }
}
