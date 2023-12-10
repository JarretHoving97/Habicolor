//
//  NotificationsListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import Foundation
import ComposableArchitecture

struct NotificationsListFeature: Reducer {
    
    let client: NotificationClient
    
    struct State: Equatable {
        var notifications: [NotificationInfo] = []
        var predicate: String?
    }
    
    enum Action: Equatable {
        case fetchLocalNotifications
        case notificationsFetched([NotificationInfo])
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .fetchLocalNotifications:
                
                return .run(operation: { [predicate = state.predicate] send in
                    
                    let results = await client.all(predicate)
                    
                    await send(.notificationsFetched(results ?? []))
                })
        
            case .notificationsFetched(let notifications):
                
                state.notifications = notifications
                
                return .none
            }
        }
    }
}
