//
//  AppFeatureView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct AppFeatureView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.habitList) { viewStore in
            
            VStack {
                HabitListView(
                    store: self.store.scope(
                        state: \.habitList,
                        action: {.habitList($0)})
                )
            }
        }
    }
}

#Preview {
    AppFeatureView(
        store: Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    )
}
