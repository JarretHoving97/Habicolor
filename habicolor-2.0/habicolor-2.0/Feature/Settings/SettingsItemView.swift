//
//  SettingsItemView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI

struct SettingsItemView: View {
    
    let title: String
    let systemIcon: String
    var action: (() -> Void)
    
    var body: some View {
        
        HStack(spacing: 10) {
            Image(systemName: systemIcon)
            Text(title)
                .themedFont(name: .medium, size: .regular)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
        }
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
    }
}

#Preview {
    SettingsItemView(
        title: "Become member",
        systemIcon: "star.fill",
        action: {})
}
