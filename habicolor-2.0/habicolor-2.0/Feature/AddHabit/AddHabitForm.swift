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
        
        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0) })) {
                WithViewStore(self.store, observe: {$0}) { viewStore in
                    ScrollView {
                        VStack(spacing: 10) {
                            DefaultTextField(
                                value: viewStore.$habitName,
                                label: "Name",
                                type: .default)
                                .themedFont(name: .regular, size: .regular)
                            
                            DefaultTextField(
                                value: viewStore.$habitDescription,
                                label: "Habit description",
                                type: .default)
                            
                            
                            ColorPicker("Color", selection: viewStore.$habitColor)
                                .themedFont(name: .semiBold, size: .title)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 4, trailing: 17))
                        
                            Text("Week goal")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                                .themedFont(name: .semiBold, size: .regular)
                            
                            Text("How many times a week do you want to stick to this habit?")
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 24))
                                .themedFont(name: .regular, size: .regular)
                        
                            Picker("Week goal", selection: viewStore.$weekGoal) {
                                ForEach(viewStore.weekgoals, id: \.self) { int in
                                    Text(int.description)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            
                            VStack {
                                HStack {
                                    Text("Reminders")
                                        .themedFont(name: .regular, size: .largeValutaSub)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Spacer()
                                    
                                    NavigationLink(state: AddHabitFeature.Path.State.addNotification(.init(notificationTitle: viewStore.habitName))) {
                                        Label("", systemImage: "plus")
                                    }
                                }
                                Text("Remind yourself to keep at you habit by a push notification")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                                    .themedFont(name: .regular, size: .regular)
                                
                                Divider()
                            }
                            .padding(.top, 10)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            
                            VStack {
                                ForEach(viewStore.notifications, id: \.self) { notificaton in
                                    
                                    NotificationView(reminder: notificaton, onDelete: {
                                        viewStore.send(.removeNotification(notificaton.id))
                                    })
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                         
                                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                            }
                            Spacer()
                            
                            Button {
                                viewStore.
                            } label: {
                                <#code#>
                            }

                        }
                        .padding(.top, 20)
                        .navigationTitle(viewStore.habitId != nil ? "Edit Habit" : "New Habit")
                        .navigationBarTitleDisplayMode(.large)
                      
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    HapticFeedbackManager.impact(style: .heavy)
                                    
                                   if viewStore.habitId == nil {
                                        viewStore.send(.saveButtonTapped)
                                   } else {
                                       viewStore.send(.editButtonTapped)
                                   }
                                
                                } label: {
                                    Label(
                                        viewStore.habitId != nil ? "Edit Habit" : "New Habit",
                                        systemImage: viewStore.habitId != nil ? "square.and.arrow.down" : "plus")
                                }
                            }
                            
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    HapticFeedbackManager.impact(style: .heavy)
                                    viewStore.send(.cancelTapped)
                                } label: {
                                    Text("Cancel")
                                }
                            }
                        }
                    }
                    
                    .onAppear {
                        
                        viewStore.send(.loadReminders)
                    }
           
                }
                .background(Color.appBackgroundColor)
            } destination: { state in
                switch state {
                case .addNotification:
                    
                    CaseLet(
                        /AddHabitFeature.Path.State.addNotification,
                         action: AddHabitFeature.Path.Action.addNotification,
                         then: AddNotificationView.init(store:)
                    )
                }
            }
    }
}

#Preview {
    
    NavigationStack {
        AddHabitForm(
            store: Store(
                initialState: AddHabitFeature.State(habitId: UUID(), notifications: [
                    Reminder(id: UUID(), days: [.monday, .tuesday, .friday],
                                 time: Date(),
                                 title: "Example",
                                 description: "This is a message to myself")
                ]),
                reducer: { AddHabitFeature() }
            )
        )
    }
    
}
