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
        WithViewStore(self.store, observe: \.habits) { viewStore in
            
            ScrollView {

                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        
                        Button("add", action: {viewStore.send(.addHabitLogButtonTapped)})
                            .padding(.trailing, 20)
                    }
                    ForEach(viewStore.state, id: \.self) { habit in
                        HabitView(
                            store: Store(
                                initialState: HabitFeature.State(habit: habit),
                                reducer: { HabitFeature()}
                            )
                        )
                    }
                }
            }
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
          state: /AppFeature.Destination.State.addHabitLog,
          action: AppFeature.Destination.Action.addHabitLog
        ) { store in

            AddHabitLogView(store: Store(initialState: AddHabitLogFeature.State(id: UUID()), reducer: {AddHabitLogFeature()}))
        }
    }
}

#Preview {
    AppFeatureView(
        store: Store(
            initialState: AppFeature.State(habits: Habit.staticContent),
            reducer: { AppFeature() }
        )
    )
}
