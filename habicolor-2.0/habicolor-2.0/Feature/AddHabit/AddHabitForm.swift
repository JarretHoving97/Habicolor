//
//  AddHabitForm.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct AddHabitForm: View {
    
    let store: StoreOf<AddHabitFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(spacing: 10) {
                DefaultTextField(
                    value: viewStore.$habitName,
                    label: "Habit Name",
                    type: .default)
                
                DefaultTextField(
                    value: viewStore.$habitMotication,
                    label: "Habit motivation",
                    type: .default)
                
                Button("Add Habit") {
                    viewStore.send(.saveButtonTapped)
                }
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 20)

        }
    }
}

#Preview {
    AddHabitForm(
        store: Store(
            initialState: AddHabitFeature.State(),
            reducer: { AddHabitFeature() }
        )
    )
}
