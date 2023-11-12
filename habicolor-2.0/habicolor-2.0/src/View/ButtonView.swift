//
//  ButtonView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import SwiftUI

struct ButtonView: View {
    
    let title: String
    
    var body: some View {
        ZStack {
            Color.primaryColor
              
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
            
            Text(title)
                .themedFont(name: .bold, size: .title)
                .foregroundStyle(Color.fullWhite)
        }
    }
}

#Preview {
    ButtonView(title: "Add")
}
