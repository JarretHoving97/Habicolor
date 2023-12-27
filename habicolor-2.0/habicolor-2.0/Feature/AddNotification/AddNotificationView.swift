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
                
                // TODO: Translations
                Text("Add notification for the following days")
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
                
                // TODO: Translations
                DatePicker("Notification time", selection: viewStore.$time, displayedComponents: .hourAndMinute)
                    .themedFont(name: .medium, size: .regular)
                    .pickerStyle(.menu)
                    .padding(.leading, 17)
                    .padding(.trailing, 17)
                
                
                VStack(spacing: 10){
                    
                    DefaultTextField(
                        value: viewStore.$notificationTitle,
                        label: "Title", // TODO: Translatuins
                        type: .default,
                        textfieldAlignment: .leading,
                        placeholder: "Appears as title in your notification.", // TODO: Translation
                        focusedField: $focus,
                        focusValue: AddNotificationFeature.State.Field.titleField,
                        submitLabel: .next
                    ) {
                        HapticFeedbackManager.selection()
                        focus = AddNotificationFeature.State.Field.descriptionField
                    }
                    
                    DefaultTextField(
                        value: viewStore.$notificationMessage,
                        label: "Message", // TODO: Translations
                        type: .default,
                        textfieldAlignment: .leading,
                        placeholder: "Appears as description in your notification", // TODO: Translations
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
                    ButtonView(title: "Add Notification")
                        .frame(height: 60)
                })
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 20, trailing: 17))
                
                
                
            }
            .padding(.top, 20)
        }
        
        // TODO: Translations
        .navigationTitle("Add Notification")
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
