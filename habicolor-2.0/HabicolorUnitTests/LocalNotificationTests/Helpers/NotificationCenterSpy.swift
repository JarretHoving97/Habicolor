//
//  NotificationCenterSpy.swift
//  HabicolorUnitTests
//
//  Created by Jarret Hoving on 21/04/2024.
//

import Foundation
import NotificationCenter
import Habicolor

public class NotificationCenterSpy: NotificationAuthorizer {
    
    let authorizationStatus: UNAuthorizationStatus
    
    init(authorizationStatus: UNAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
    }
    
    public func authorizationStatus() async -> UNAuthorizationStatus {
        return authorizationStatus
    }
    
    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return true
    }
}
