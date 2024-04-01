//
//  SettingsPickerView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/12/2023.
//

import SwiftUI


struct SettingsPickerView: View {
    let title: String
    let systemIcon: String
    @Binding var selection: String
    
    let options: [String]
    
    var body: some View {
        HStack {
            Image(systemName: systemIcon)
            Text(title)
                .themedFont(name: .medium, size: .regular)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
            
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
        }
        .themedFont(name: .medium, size: .regular)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
    }
}

#Preview {
    @State var selection = "System"
    let options = ["System", "Light", "Dark"]
    return SettingsPickerView(
        title: "Color Scheme",
        systemIcon: "moon.fill",
        selection: $selection,
        options: options
    )
}
