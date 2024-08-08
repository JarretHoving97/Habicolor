//
//  DefaultTextField.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI

struct DefaultTextField<Value: Hashable>: View {
    
    @Binding var value: String
    
    var focusedField: FocusState<Value?>.Binding
    var focusValue: Value
    
    let label: String
    let type: UIKeyboardType
    let textfieldAlignment: TextAlignment
    let labelAlignment: Alignment
    let placeholder: String
    let submitLabel: SubmitLabel
    let onSubmit: (() -> Void)?
    
    
    init(value: Binding<String>, label: String, type: UIKeyboardType, textfieldAlignment: TextAlignment, placeholder: String, focusedField: FocusState<Value?>.Binding, focusValue: Value?, submitLabel: SubmitLabel? = nil, onSubmit: (() -> Void)? = nil) {
        _value = value
        self.focusedField = focusedField
        self.focusValue = focusValue ?? UUID().uuidString as! Value
        self.label = label
        self.type = type
        self.textfieldAlignment = textfieldAlignment
        self.labelAlignment = textfieldAlignment == .leading ? .leading : .center
        self.placeholder = placeholder
        self.submitLabel = submitLabel ?? .done
        self.onSubmit = onSubmit
    }

    
    var body: some View {
        
        ZStack {
            VStack {
                Text(label)
                    .frame(maxWidth: .infinity, maxHeight: 16, alignment: labelAlignment)
                    .multilineTextAlignment(textfieldAlignment)
                    .themedFont(name: .medium, size: .regular)
                    .foregroundStyle(Color.appTextColor)
                
                TextField(placeholder, text: $value)
                    .multilineTextAlignment(textfieldAlignment)
                    .keyboardType(type)
                    .themedFont(name: .regular, size: .regular)
                    .focused(focusedField, equals: focusValue)
                    .onSubmit() {
                        onSubmit?()
                    }
                    .submitLabel(submitLabel)
                
                Divider()
            }
            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
        }
       
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
    }
}
#Preview {
    
    @State var value: String = ""
    
    
    return DefaultTextView(title: "Namer", text: $value)
}
