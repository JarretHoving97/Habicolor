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
                            
                            Text("Templates")
                                .themedFont(name: .medium, size: .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 17)
                            
                            HabitTemplateView(
                                store: self.store.scope(
                                    state: \.habitTemplateFeature,
                                    action: AddHabitFeature.Action.habitTemplateFeature
                                )
                            )
                            .padding(.bottom, 10)
                            
                            DefaultTextField(
                                value: viewStore.$habitName,
                                label: trans("add_habit_form_habit_name_label"),
                                type: .default,
                                textfieldAlignment: .leading,
                                placeholder: trans("add_habit_form_habit_name_placeholder"),
                                focusedField: $focus,
                                focusValue: AddHabitFeature.State.Field.habitName,
                                submitLabel: .next
                                
                            ) {
                                HapticFeedbackManager.selection()
                                self.focus = .habitMotivation
                            }
                            
                            
                            DefaultTextField(
                                value: viewStore.$habitDescription,
                                label: trans("add_habit_form_habit_note_to_self_title"),
                                type: .default,
                                textfieldAlignment: .leading,
                                placeholder: trans("add_habit_form_habit_note_to_self_placeholder"),
                                focusedField: $focus,
                                focusValue: AddHabitFeature.State.Field.habitMotivation,
                                submitLabel: .done
                            ) {
                                HapticFeedbackManager.selection()
                                self.focus = nil
                            }
                            
                            ColorPicker(trans("add_habit_form_color_picker_title"), selection: viewStore.$habitColor)
                                .themedFont(name: .semiBold, size: .title)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 4, trailing: 17))
                            
                            Text(trans("add_habit_form_week_goal_title"))
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                                .themedFont(name: .semiBold, size: .regular)
                            
                            Text(trans("add_habit_form_week_goal_description"))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 24))
                                .themedFont(name: .regular, size: .regular)
                            
                            Picker(trans("add_habit_form_week_goal_title"), selection: viewStore.$weekGoal) {
                                ForEach(viewStore.weekgoals, id: \.self) { int in
                                    Text(int.description)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            
                            VStack {
                                HStack {
                                    Text(trans("add_habit_form_reminders_section_title"))
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
                                Text(trans("add_habit_form_reminders_section_description"))
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
                        .navigationTitle(viewStore.habitId != nil ? trans("add_habit_form_view_title_edit") : trans("add_habit_form_view_title_new"))
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
                                        viewStore.habitId != nil ? trans("add_habit_form_view_title_edit") : trans("add_habit_form_view_title_new"),
                                        systemImage: viewStore.habitId != nil ? "square.and.arrow.down" : "plus")
                                }
                            }
                            
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    HapticFeedbackManager.impact(style: .heavy)
                                    viewStore.send(.cancelTapped)
                                } label: {
                                    Text(trans("add_habit_form_cancel_nav_button_title"))
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
