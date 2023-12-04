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
    
    struct State {
        var notifications: [NotificationInfo] = []
        var predicate: String?
    }
    
    enum Action {
        case fetchLocalNotifications
        case notificationsFetched([NotificationInfo])
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .fetchLocalNotifications:
                
                self.client.all(state.predicate) { results in
                    
                    Log.debug(results.description)
                }
                
                return .none
                
            case .notificationsFetched(let notifications):
                
                return .none
            }
        }
    }
}
