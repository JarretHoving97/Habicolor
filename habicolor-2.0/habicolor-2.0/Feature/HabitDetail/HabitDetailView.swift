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
        
                    Text(trans("habit_detail_view_this_week_title"))
                        .themedFont(name: .bold, size: .large)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                   
                    Text(trans("habit_detail_view_this_week_description"))
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
                        .padding(EdgeInsets(top: 20, leading: 17, bottom: 30, trailing: 17))
                      
                        
                        VStack {
                            Text(trans("habit_detail_view_week_goal_label"))
                                .themedFont(name: .regular, size: .small)
                            Text(viewStore.weekGoal.description)
                                .themedFont(name: .bold, size: .regular)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(EdgeInsets(top: 20, leading: 17, bottom: 30, trailing: 17))
                    }
            
                    .background(Color.appBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .shadowColor, radius: 25, x: 0, y: 25)
                
                    Text(trans("habit_detail_view_year_overview_title"))
                        .themedFont(name: .bold, size: .largeValutaSub)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
          
                    Text(trans("habit_detail_view_year_overview_description"))
                        .themedFont(name: .regular, size: .small)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .opacity(0.4)
                    
                    
                    
                    ContributionView(
                        store: self.store.scope(
                            state: \.contributionFeature,
                            action: HabitDetailFeature.Action.contributionFeature
                        ),
                        color: viewStore.color
                    )
                    .padding(EdgeInsets(top: 20, leading: 17, bottom: 20, trailing: 17))
                    
                    .background(Color.appBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .shadowColor, radius: 25, x: 0, y: 25)
                    
                    VStack {
        
                        Text(trans("habit_detail_view_habit_description_title_label"))
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
                            Label(trans("habit_detail_view_toolbar_edit_button_label"), systemImage: "square.and.pencil")
                        }
                        .disabled(viewStore.id == Habit.example.id)
                        
                        Button {
                            viewStore.send(.delegate(.didTapNotficaitions(viewStore.state)))
                        } label: {
                            Label(trans("habit_detail_view_toolbar_reminder_button_label"), systemImage: "bell.badge")
                        }
                        .disabled(viewStore.id == Habit.example.id)
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            viewStore.send(.showDeleteAlert)
                            
                        } label: {
                            
                            Label(trans("habit_detail_view_toolar_delete_button_label"), systemImage: "trash")
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
                    habit: .example,
                    contributionFeature: ContributionFeature.State(habit: Habit.example.id, previousWeeks: Contribution.generateAWholeYear()),
                    habitStatsFeature: HabitStatsFeature.State(habit: .example)
                ),
                reducer: { HabitDetailFeature(habitLogClient: .live) }
            )
        )
    }
}
