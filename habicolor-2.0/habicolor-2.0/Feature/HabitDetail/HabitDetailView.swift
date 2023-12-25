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
                    
                    ZStack {
                        
                        HabitStatsView(
                            store: self.store.scope(
                                state: \.habitsStatsFeature,
                                action: HabitDetailFeature.Action.habitsStatsFeature
                            )
                        )
                        
                        VStack {
                            Text("Week goal") // Translations
                                .themedFont(name: .regular, size: .small)
                            
                            Text(viewStore.weekGoal.description)
                                .themedFont(name: .bold, size: .regular)
                        }
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
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
                        store: self.store.scope(
                            state: \.contributionFeature,
                            action: HabitDetailFeature.Action.contributionFeature
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
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 24))
                            .themedFont(name: .regular, size: .regular)
                        
                    }
                    .padding(.top, 10)
                    
                }
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            .navigationTitle(viewStore.name)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        
                        Button {
                            viewStore.send(.editHabitTapped(viewStore.state))
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil") // TODO: Translations
                        }
                        
                        Button {
                            viewStore.send(.delegate(.didTapNotficaitions(viewStore.state)))
                        } label: {
                            Label("Reminders", systemImage: "bell.badge") // TODO: Translations
                            
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            viewStore.send(.showDeleteAlert)
                            
                        } label: {
                            
                            Label("Delete", systemImage: "trash") // TODO: Translations
                                .foregroundColor(.red)
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
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
