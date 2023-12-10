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
                                weekgoal: viewStore.weekGoal,
                                color: viewStore.color, habit: viewStore.id),
                            reducer: {HabitStatsFeature(client: .live)}
                        )
                    )
                    
                    ContributionView(
                        store: Store(
                            initialState: ContributionFeature.State(habit: viewStore.id),
                            reducer: { ContributionFeature(client: .live)}
                        ),
                        color: viewStore.color
                    )
                    .padding(EdgeInsets(top: -20, leading: -17, bottom: 0, trailing: -17))
                    
                    VStack {
                        
                        Text("Habit description")
                            .themedFont(name: .medium, size: .title)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        
                        Text(viewStore.description)
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
