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
    
    @FocusState var focus: AddHabitFeature.State.Field?
    
    var body: some View {
        
        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0) })) {
                WithViewStore(self.store, observe: {$0}) { viewStore in
                    ScrollView {
                        VStack(spacing: 10) {
                            
                            DefaultTextField(
                                value: viewStore.$habitName,
                                label: "Name", // TODO: Translations
                                type: .default,
                                textfieldAlignment: .leading,
                                placeholder: "Name", // TODO: Translations
                                focusedField: $focus,
                                focusValue: AddHabitFeature.State.Field.habitName,
                                submitLabel: .next
                                
                            ) {
                                HapticFeedbackManager.selection()
                                self.focus = .habitMotivation
                            }
                            
                            DefaultTextField(
                                value: viewStore.$habitDescription,
                                label: "A note to yourself", // TODO: Translations
                                type: .default,
                                textfieldAlignment: .leading,
                                placeholder: "Describe what motivates you for example", // TODO: Translations
                                focusedField: $focus,
                                focusValue: AddHabitFeature.State.Field.habitMotivation,
                                submitLabel: .done
                            ) {
                                HapticFeedbackManager.selection()
                                self.focus = nil
                            }
                            
                            ColorPicker("Color", selection: viewStore.$habitColor) // TODO: Translations
                                .themedFont(name: .semiBold, size: .title)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 4, trailing: 17))
                            
                            Text("Week goal")// TODO: Translations
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                                .themedFont(name: .semiBold, size: .regular)
                            
                            Text("How many times a week do you want to stick to this habit?") // TODO: Translations
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 24))
                                .themedFont(name: .regular, size: .regular)
                            
                            // TODO: Translations
                            Picker("Week goal", selection: viewStore.$weekGoal) {
                                ForEach(viewStore.weekgoals, id: \.self) { int in
                                    Text(int.description)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            
                            VStack {
                                HStack {
                                    // TODO: Translations
                                    Text("Reminders")
                                        .themedFont(name: .regular, size: .largeValutaSub)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Spacer()
                                    
                                    Button {
                                        focus = nil
                                        viewStore.send(.addNotificationTapped)
                                    } label: {
                                        Label("", systemImage: "plus")
                                    }
                                }
                                // TODO: Translations
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
                                        viewStore.send(.removeNotification(notificaton.id), animation: .easeOut)
                                    })
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                            }
                            Spacer()
                            
                        }
                        .padding(.top, 20)
                        // TODO: Translations
                        .navigationTitle(viewStore.habitId != nil ? "Edit Habit" : "New Habit")
                        .navigationBarTitleDisplayMode(.large)
                        
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    
                                    // hide keyboard
                                    focus = nil
                                    
                                    if viewStore.habitId == nil {
                                        viewStore.send(.saveButtonTapped)
                                    } else {
                                        viewStore.send(.editButtonTapped)
                                    }
                                    
                                } label: {
                                    Label(
                                        // TODO: Translations
                                        viewStore.habitId != nil ? "Edit Habit" : "New Habit",
                                        systemImage: viewStore.habitId != nil ? "square.and.arrow.down" : "plus")
                                }
                            }
                            
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    HapticFeedbackManager.impact(style: .heavy)
                                    viewStore.send(.cancelTapped)
                                } label: {
                                    Text("Cancel") // TODO: Translations
                                }
                            }
                        }
                    }
                    
                    .onAppear {
                        viewStore.send(.loadReminders)
                    }
                    
                }
                .background(Color.appBackgroundColor)
                
                .alert(
                    store: self.store.scope(
                        state: \.$destination,
                        action:  { .destination($0)}),
                    state: /AddHabitFeature.Destination.State.alert,
                    action: AddHabitFeature.Destination.Action.alert
                )
                
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
