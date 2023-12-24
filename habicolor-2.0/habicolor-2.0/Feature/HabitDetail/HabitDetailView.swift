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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("This week")
                        .themedFont(name: .bold, size: .large)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                    
                    Text("See your week goal completion progress and average score.")
                        .themedFont(name: .regular, size: .regular)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                        .opacity(0.4)
                    
                    HabitStatsView(
                        store: Store(
                            initialState: HabitStatsFeature.State(
                                weekgoal: viewStore.weekGoal,
                                color: viewStore.color,
                                habit: viewStore.id
                            ),
                            reducer: { HabitStatsFeature(client: .live) }
                        )
                    )
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                    Divider()
                    

                    Text("Year overview")
                        .themedFont(name: .bold, size: .largeValutaSub)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                    
                    Text("This graph tracks your difficulty for sticking to your habit. How brighter the color, how easy it was for you to complete this habit.")
                        .themedFont(name: .regular, size: .small)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        .opacity(0.4)
                    
                    ContributionView(
                        store: Store(
                            initialState: ContributionFeature.State(habit: viewStore.id),
                            reducer: { ContributionFeature(client: .live)}
                        ),
                        color: viewStore.color
                    )
                    .padding(EdgeInsets(top: -20, leading: -17, bottom: 0, trailing: -17))
                    
                    Divider()
                    
                    VStack {
                        Text("Habit description")
                            .themedFont(name: .bold, size: .largeValutaSub)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text(viewStore.description)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                            .themedFont(name: .regular, size: .regular)
                        
                    }
                    .padding(.top, 10)
                    
                    Button {
                        viewStore.send(.showDeleteAlert)
                        
                    } label: {
                        Text("Delete")
                            .tint(Color.redColor)
                    }
                    .padding(.top, 20)
                    
                    
                }
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            .navigationTitle(viewStore.name)
            .navigationBarTitleDisplayMode(.inline)
            
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
        .alert(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitDetailFeature.Destination.State.alert,
            action: HabitDetailFeature.Destination.Action.alert
        )
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
