//
//  DefaultTextField.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI

struct DefaultTextField: View {
    
    @Binding var value: String
    let label: String
    let type: UIKeyboardType
    let textfieldAlignment: TextAlignment
    let labelAlignment: Alignment
    let placeholder: String
    
    init(value: Binding<String>, label: String, placeholder: String? = nil, type: UIKeyboardType, alignment: TextAlignment = .leading) {
        _value = value
        self.label = label
        self.type = type
        self.textfieldAlignment = alignment
        self.placeholder = placeholder ?? label
        self.labelAlignment = textfieldAlignment == .leading ? .leading : .center
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                Text(label)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 16, alignment: labelAlignment)
                    .multilineTextAlignment(textfieldAlignment)
                    .themedFont(name: .medium, size: .regular)
                
                TextField(placeholder, text: $value)
                    .multilineTextAlignment(textfieldAlignment)
                    .keyboardType(type)
                    .themedFont(name: .regular, size: .regular)
                
                Divider()
            }
            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
        }
       
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
    }
}
#Preview {
    
    @State var value: String = ""
    
    
    return DefaultTextField(value: $value, label: "Kaas?", type: .default)
}
