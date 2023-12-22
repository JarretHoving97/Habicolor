//
//  UpgradePremiumButton.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI

struct UpgradePremiumButton: View {
    
    
    var body: some View {
        ZStack {
            Color.primaryColor.opacity(0.05)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
            HStack {
                Text("Get Plus")
                    .themedFont(name: .semiBold, size: .regular)
                    .foregroundStyle(Color.primaryColor)
                
                Image(systemName: "sparkles")
                    .resizable()
                    .frame(width: 14, height: 16)
                    .padding(.bottom, 4)
                    .foregroundStyle(Color.primaryColor.opacity(0.8))
         
            }
            .padding(6)
        }
        .frame(width: 112, height: 30)
    }
}

#Preview {
    UpgradePremiumButton()
}
