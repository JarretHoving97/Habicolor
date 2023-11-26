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
        WithViewStore(self.store, observe: {$0})
        { viewStore in
            ScrollView {
                VStack {
                    HabitStatsView(
                        store: Store(
                            initialState: HabitStatsFeature.State(
                                logs: viewStore.logs,
                                weekgoal: viewStore.habit.weekGoal,
                                color: viewStore.habit.color
                            ),
                            reducer: { HabitStatsFeature() }
                        )
                    )
                    
                    ContributionView(
                        store: Store(
                            initialState: ContributionFeature.State(logs: viewStore.logs),
                            reducer: {ContributionFeature()}
                        ),
                        color: viewStore.habit.color
                    )
                    .padding(EdgeInsets(top: -20, leading: -17, bottom: 0, trailing: -17))
                    
                    VStack {
    
                        Text("Habit description")
                            .themedFont(name: .medium, size: .title)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        
                        Text(viewStore.habit.description)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                            .themedFont(name: .regular, size: .regular)
                        
                    }
                    .padding(.top, 10)
                    
                }
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            .navigationTitle(viewStore.habit.name)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.editHabitTapped(viewStore.habit))
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            
            .onAppear {
                viewStore.send(.loadLogs)
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
                reducer: { HabitDetailFeature(habitLogClient: .live) }
            )
        )
    }
}
