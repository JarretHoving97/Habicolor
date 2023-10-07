//
//  AddHabitLogView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct AddHabitLogView: View {
    
    let store: StoreOf<AddHabitLogFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            Text("Log your habit score here..")
        }
    }
}

#Preview {
    AddHabitLogView(
        store: Store(
            initialState: AddHabitLogFeature.State(id: UUID()),
            reducer: {AddHabitLogFeature()
            }
        )
    )
}
