//
//  SettingsSwitchView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI

struct SettingsSwitchView: View {
        
    let title: String
    let systemIcon: String
    @Binding var enabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: systemIcon)
            Toggle(title, isOn: $enabled)
                .tint(.primaryColor)
                .themedFont(name: .medium, size: .regular)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
        }
    }
}

#Preview {
    @State var enabled: Bool = false
    return SettingsSwitchView(
        title: "Haptic feedback",
        systemIcon: "water.waves",
        enabled: $enabled
    )
}
