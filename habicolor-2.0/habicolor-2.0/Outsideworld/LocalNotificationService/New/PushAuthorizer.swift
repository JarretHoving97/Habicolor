//
//  PushAuthorizer.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/04/2024.
//

import Foundation
import NotificationCenter

public protocol NotificationAuthorizer {
    func authorizationStatus() async -> UNAuthorizationStatus
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
}
