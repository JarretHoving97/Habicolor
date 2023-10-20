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
        
//        NavigationStackStore(
//            self.store.scope(state: \.path, action: { .path($0) })
//        ) {
            HabitListView(store: Store(initialState: HabitListFeature.State(), reducer: {HabitListFeature()}))
//        } destination: { store in
//            
//            switch store {
//            case .habitDetail:
//                
//                CaseLet(
//                    /AppFeature.Path.State.habitDetail,
//                     action: AppFeature.Path.Action.habitDetail,
//                     then: HabitDetailView.init(store:))
//                
//                
//                
//            case .addHabit:
//                
//                CaseLet(
//                    /AppFeature.Path.State.addHabit,
//                     action: AppFeature.Path.Action.addHabit,
//                     then: AddHabitForm.init(store:))
//            }
//            
//        }
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
