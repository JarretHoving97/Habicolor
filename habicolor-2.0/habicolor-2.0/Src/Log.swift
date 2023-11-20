//
//  Log.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//


import Foundation

class Log {
    static func debug(_ message: String) {
        #if DEBUG
        print("")
        print("👨🏽‍💻 - \(message)")
        print("")
        #endif
    }
    
    static  func error(_ message: String) {
        #if DEBUG
        print("")
        print("❌ - \(message)")
        print("")
        #endif
    }
    
    static func event(_ message: String) {
        #if DEBUG
        print("")
        print("✉️ EVENT: - \(message)")
        print("")
        #endif
    }
}
