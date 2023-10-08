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
            Text("add Habit here..")
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
