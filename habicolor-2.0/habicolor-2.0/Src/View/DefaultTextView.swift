//
//  DefaultTextView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/10/2023.
//

import SwiftUI

struct DefaultTextView: View {
    
    var title: String
    
    @Binding var text: String
    
    var showInvalid: Binding<Bool>?
    
    var lineLimit: Int = 5
    
    var body: some View {
        
        VStack {
            Text(title)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .multilineTextAlignment(.leading)
                .themedFont(name: .semiBold, size: .regular)
            
            TextField(title, text: $text, axis: .vertical)            
                .listRowBackground(Color.appBackgroundColor)
                .themedFont(name: .regular, size: .regular)
                .lineLimit(lineLimit, reservesSpace: true)
            
                .foregroundColor(Color.appTextColor)
                .accentColor(.primaryColor)
            
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primaryColor, lineWidth: showInvalid?.wrappedValue ?? false && text.isEmpty ? 2 : 0)
            )
            
            Divider()
        }
        .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
    }
}

#Preview {
    
    @State var invalid: Bool = false
    @State var text: String = ""
    
    return  DefaultTextView(
        title: "Voorbeeld",
        text: $text,
        showInvalid: $invalid,
        lineLimit: 10
    )
}
