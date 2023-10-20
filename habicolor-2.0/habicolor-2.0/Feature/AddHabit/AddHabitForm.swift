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
                    VStack(spacing: 10) {
                        DefaultTextField(
                            value: viewStore.$habitName,
                            label: "Name",
                            type: .default)
                        
                        
                        DefaultTextView(
                            title: "Motivation",
                            text: viewStore.$habitDescription, lineLimit: 2)
                        
                        Text("Week goal")
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            .themedFont(name: .semiBold, size: .regular)
                        
                        
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
                                
                                NavigationLink(state: AddHabitFeature.Path.State.addNotification(.init())) {
                                    Label("", systemImage: "plus")
                                }
                            }
                            Text("Remind yourself to keep at you habit by a push notification")
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                 
                          
                        }
                        .padding(.top, 10)
                        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
            
                        
                        ForEach(viewStore.notifications, id: \.self) { notificaton in
                            
                            VStack {
                                
                                HStack {
                                    Image.Icons.notificationOn
                                        .foregroundStyle(Color.appTextColor)
                                    
                                    Text(notificaton.time.formatToDateString(with: .time))
                                        .themedFont(name: .bold, size: .title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(Color.appTextColor)
                                }
                              
                                
                                HStack {
                                    ForEach(notificaton.days, id: \.self) { weekday in
                                        Text(weekday.localizedString.prefix(3) + ",")
                                            .themedFont(name: .regular, size: .small)
                                            .foregroundStyle(Color.appTextColor)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.4)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
            
                        
                        Spacer()
                    
                    }
                    .padding(.top, 20)
                    .navigationTitle("New Habit")
                    
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                HapticFeedbackManager.impact(style: .heavy)
                                viewStore.send(.saveButtonTapped)
                            } label: {
                                Label("Add New habit", systemImage: "plus")
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
                initialState: AddHabitFeature.State(notifications: [
                    Notification(days: [.monday, .tuesday, .friday],
                                 time: Date(),
                                 title: "Example",
                                 description: "")
                ]),
                reducer: { AddHabitFeature() }
            )
        )
    }
    
}
