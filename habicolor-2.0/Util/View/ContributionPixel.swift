//
//  ContributionPixel.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/11/2023.
//

import SwiftUI

struct ContributionPixel: View {
    

    let color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    var body: some View {
        square()
    }

    @ViewBuilder private func square() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.cardColor)
            Rectangle()
                .fill(color)
        }
    }
}

#Preview {
    ContributionPixel(color: .blue)
}

