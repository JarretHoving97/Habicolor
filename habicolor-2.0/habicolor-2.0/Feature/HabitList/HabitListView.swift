//
//  HabitListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitListView: View {
    
    let store: StoreOf<HabitListFeature>
    
    var body: some View {
        
        NavigationStackStore(
            self.store.scope(
                state: \.path,
                action: {.path($0)})
        ) {
            WithViewStore(self.store, observe: \.habits) { viewStore in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewStore.state, id: \.self) { habit in
                            
                            NavigationLink(state: HabitListFeature.Path.State.habitDetail(.init(habit: habit))) {
                                HabitView(
                                    store: Store(
                                        initialState: HabitFeature.State(habit: habit),
                                        reducer: { HabitFeature()}
                                    )
                                )
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                HapticFeedbackManager.impact(style: .heavy)
                                viewStore.send(.addHabitTapped)
                            } label: {
                                Label("Add New habit", systemImage: "pencil.tip.crop.circle.badge.plus")
                            }
                            
                        } label: {
                            
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                .background(Color.appBackgroundColor)
                
            }
        } destination: {
            switch $0 {
                
            case .habitDetail:
                CaseLet(
                    /HabitListFeature.Path.State.habitDetail,
                     action: HabitListFeature.Path.Action.habitDetail,
                     then: HabitDetailView.init(store:))
            }
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitListFeature.Destination.State.addHabitForm,
            action: HabitListFeature.Destination.Action.addHabitForm
        ) { store in
            AddHabitForm(store: store)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    HabitListView(store: Store(
        initialState: HabitListFeature.State(),
        reducer: { HabitListFeature() }
    ))
}
