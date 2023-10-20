//
//  HabitDetailView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitDetailView: View {
    
    let store: StoreOf<HabitDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            Text(viewStore.habit.description)
                .navigationTitle(viewStore.habit.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
//                            viewStore.send(.editHabitPressed)
                            
                        }, label: {
                            Image(systemName: "square.and.pencil")
                        })
                    }
                }
        }
    }
}

#Preview {
    
    NavigationStack {
        HabitDetailView(
            store: Store(
                initialState: HabitDetailFeature.State(
                    habit: .example),
                reducer: {HabitDetailFeature() }
            )
        )
    }
}
