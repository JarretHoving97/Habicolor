//
//  Task+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 31/12/2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
