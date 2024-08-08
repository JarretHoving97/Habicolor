//
//  String+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/12/2023.
//

import Foundation

// MARK: For translations
extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

public func trans(_ key: String, comment: String = "") -> String {
    return key.localized(comment: comment)
}
