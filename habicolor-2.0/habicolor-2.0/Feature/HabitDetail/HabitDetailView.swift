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
        WithViewStore(self.store, observe: \.habit)
        { viewStore in
            ScrollView {
                
                VStack {
   
                    HabitStatsView(
                        store: Store(
                            initialState: HabitStatsFeature.State(
                                logs: HabitLog.generateYear(),
                                weekgoal: viewStore.weekGoal
                            ),
                            reducer: { HabitStatsFeature() }
                        )
                    )
                
           
                    ContributionView(
                        store: Store(
                            initialState: ContributionFeature.State(logs: HabitLog.generateYear()),
                            reducer: {ContributionFeature()}
                        )
                    )
                    .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                    
             
         
              
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 17, leading: 0, bottom: 0, trailing: 0))
                
               
            }

            .navigationTitle(viewStore.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.editHabitTapped(viewStore.state))
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitDetailFeature.Destination.State.edit,
            action: HabitDetailFeature.Destination.Action.edit
        ) { store in
            AddHabitForm(store: store)
                .interactiveDismissDisabled()
        }
        .background(Color.appBackgroundColor)
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
