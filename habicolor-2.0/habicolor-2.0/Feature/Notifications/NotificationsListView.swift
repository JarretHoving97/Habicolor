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
        WithViewStore(self.store, observe: \.notifications) { viewStore in
            ForEach(viewStore.state, id: \.self) { notication in
                Text(notication.identifier)
            }
        }
    }
}

#Preview {
    NotificationsListView(
        store: Store(
            initialState: NotificationsListFeature.State(),
            reducer: { NotificationsListFeature(client: .live) }
        )
    )
}
