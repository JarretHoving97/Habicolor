//
//  NotificationsListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct NotificationsListView: View {
    
    let store: StoreOf<NotificationsListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.reminders) { viewStore in
            ZStack {
                if viewStore.isEmpty {
                    VStack {

                        Text(trans("notifications_list_view_empty_state_title"))
                            .themedFont(name: .medium, size: .title)
                        
                        Text(trans("notifications_list_view_empty_state_description"))
                            .themedFont(name: .regular, size: .regular)
                            .opacity(0.4)
                            .frame(alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                    .padding(17)
               
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(viewStore.keys).sorted(by: {$0.name < $1.name}), id: \.self) { habit in
                                
                                VStack(spacing: 10) {
                                    HStack {
                                        Text(habit.name)
                                            .themedFont(name: .bold, size: .title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    VStack(spacing: 20) {
                                        ForEach(viewStore[habit] ?? [], id: \.self) { reminder in
                                            
                                            VStack {
                                                NotificationView(reminder: reminder) {
                                                    viewStore.send(.deleteNotification(
                                                        habit: habit, reminder: reminder), animation: .easeInOut)
                                                }
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                }
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    }
              
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackgroundColor)
            .onAppear {
                viewStore.send(.fetchLocalNotifications)
            }
    
        }
    }
}

#Preview {
    NotificationsListView(
        store: Store(
            initialState: NotificationsListFeature.State(habits: [.example]),
            reducer: { NotificationsListFeature(
                localNotificationClient: .localCenter,
                notificationStorageSerice: .live
                )
            }
        )
    )
}
