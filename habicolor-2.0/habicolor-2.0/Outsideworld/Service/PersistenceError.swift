//
//  PersistenceError.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/10/2023.
//

import Foundation

enum PersistenceError: Error {
    case loadError
    case deletionError
    case saveError
    case updateError
}
