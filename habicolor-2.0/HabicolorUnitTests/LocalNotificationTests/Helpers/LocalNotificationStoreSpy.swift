//
//  LocalNotificationStoreSpy.swift
//  HabicolorUnitTests
//
//  Created by Jarret Hoving on 21/04/2024.
//

import Foundation
import Habicolor
import NotificationCenter

public class NotificationStoreSpy: LocalNotificationStore {
    
    let authorizer: NotificationAuthorizer
    
    var store = [UNNotificationRequest]()
    
    enum Error: Swift.Error {
        case unauthorizedForPushNotifications
    }
    
    init(authorizer: NotificationAuthorizer = NotificationCenterSpy(authorizationStatus: .authorized)
, store: [UNNotificationRequest] = [UNNotificationRequest]()) {
        self.authorizer = authorizer
        self.store = store
    }
    
    public func addNotification(_ notification: LocalNotification) async throws {
        
        guard await authorizer.authorizationStatus() == .authorized else {
            throw Error.unauthorizedForPushNotifications
        }
        
        store.append(notification.toNotificationRequest())
    }
    
    public func getPendingRequests() async -> [LocalNotification] {
        return store.map { $0.toModel() }
    }
    
    public func removePendingRequests(with identifiers: [String]) {
        identifiers.forEach { id in
            store.removeAll(where: {$0.identifier == id})
        }
    }
}
