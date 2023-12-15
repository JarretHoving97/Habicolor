//
//  SettingsSwitchView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI

struct SettingsSwitchView: View {
    
    let title: String
    @State var enabled: Bool = false
    
    var body: some View {
        Toggle(title, isOn: $enabled)
            .tint(.primaryColor)
            .themedFont(name: .semiBold, size: .regular)
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
    }
}

#Preview {
    @State var enabled: Bool = false
    return SettingsSwitchView(
        title: "Haptic feedback"
    )
}
