//
//  SettingsItemProgressView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 22/12/2023.
//

import SwiftUI

struct SettingsItemProgressView: View {
    
    let title: String
    let systemIcon: String
    var action: (() -> Void)
    var showIndicator: Binding<Bool>
    
    var body: some View {
        
        Button(action: {
            HapticFeedbackManager.selection()
            action()
        }, label: {
            HStack(spacing: 10) {
                Image(systemName: systemIcon)
                Text(title)
                    .themedFont(name: .medium, size: .regular)
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                
                if showIndicator.wrappedValue {
                    ProgressView()
                        .tint(Color.appTextColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
        })
    }
}

#Preview {
    
    @State var showIndicator: Bool = true
    
    return SettingsItemProgressView(
        title: "Become member",
        systemIcon: "star.fill",
        action: {},
        showIndicator: $showIndicator)
}
