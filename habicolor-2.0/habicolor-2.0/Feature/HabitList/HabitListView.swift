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
        WithViewStore(self.store, observe: \.habits) { viewStore in
            ScrollView {
                ForEach(viewStore.state, id: \.self) { habit in
                    HabitView(
                        store: Store(
                            initialState: HabitFeature.State(habit: habit),
                            reducer: { HabitFeature()}
                        )
                    )
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
            }
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
          state: /HabitListFeature.Destination.State.addHabitForm,
          action: HabitListFeature.Destination.Action.addHabitForm
        ) { store in
            AddHabitForm(store: store)
        }
    }
}

#Preview {
    HabitListView(store: Store(
        initialState: HabitListFeature.State(),
        reducer: { HabitListFeature() }
    ))
}
