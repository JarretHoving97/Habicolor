//
//  AddNotificationView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct AddNotificationView: View {
    
    let store: StoreOf<AddNotificationFeature>
    
    @FocusState private var focus: AddNotificationFeature.State.Field?
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            
            VStack(spacing: 12) {
    
                Text(trans("add_notification_view_choose_days_label"))
                    .themedFont(name: .medium, size: .regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 17)
                    .padding(.trailing, 17)
                
                SelectWeekDaysView(
                    store: self.store.scope(
                        state: \.selectWeekDays,
                        action: {.selectWeekDays($0)}
                    )
                )
                
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                
                DatePicker(trans("add_notification_view_time_label"), selection: viewStore.$time, displayedComponents: .hourAndMinute)
                    .themedFont(name: .medium, size: .regular)
                    .pickerStyle(.menu)
                    .padding(.leading, 17)
                    .padding(.trailing, 17)
                
                
                VStack(spacing: 10){
                    
                    DefaultTextField(
                        value: viewStore.$notificationTitle,
                        label: trans("add_notification_view_notification_title_label"),
                        type: .default,
                        textfieldAlignment: .leading,
                        placeholder: trans("add_notification_view_notification_placeholder_label"),
                        focusedField: $focus,
                        focusValue: AddNotificationFeature.State.Field.titleField,
                        submitLabel: .next
                    ) {
                        HapticFeedbackManager.selection()
                        focus = AddNotificationFeature.State.Field.descriptionField
                    }
                    
                    DefaultTextField(
                        value: viewStore.$notificationMessage,
                        label: trans("add_notification_view_notification_message_title_label"),
                        type: .default,
                        textfieldAlignment: .leading,
                        placeholder: trans("add_notification_view_notification_message_description_label"),
                        focusedField: $focus,
                        focusValue: AddNotificationFeature.State.Field.descriptionField,
                        submitLabel: .done
                    ) {
                        HapticFeedbackManager.selection()
                        focus = nil
                    }

                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    viewStore.send(.addNotification)
                }, label: {
                    ButtonView(title: trans("add_notification_view_notification_add_button_title_label"))
                        .frame(height: 60)
                })
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 20, trailing: 17))
                
                
                
            }
            .padding(.top, 20)
        }

        .navigationTitle(trans("add_notification_view_notification_nav_title"))
        
        .alert(
            store: self.store.scope(
                state: \.$destination,
                action:  { .destination($0)}),
            state: /AddNotificationFeature.Destination.State.alert,
            action: AddNotificationFeature.Destination.Action.alert
        )
    }
}

#Preview {
    NavigationStack {
        AddNotificationView(
            store: Store(
                initialState: AddNotificationFeature.State(),
                reducer: {AddNotificationFeature()})
        )
    }
}
