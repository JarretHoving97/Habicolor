//
//  Emoji.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 22/10/2023.
//

import Foundation


enum Emoji: Int, CaseIterable {
    case terrible = 1
    case hard
    case neutral
    case happy
    case great
}

extension Emoji {
    
    var icon: String {
        switch self {
        case .terrible:
            return "😓"
        case .hard:
            return "🙁"
        case .neutral:
            return "😐"
        case .happy:
            return "😄"
        case .great:
            return "🤩"
        }
    }
}
