//
//  CircularProgressView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import SwiftUI

struct CircularProgressView: View {
    
    var lineWidth: CGFloat = 12
    var progress: Double = 0.2
    var foreGroundColor: Color = Color.secondaryColor
    var textFontSize: ScaledFont.ThemeFontSize = .large
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    foreGroundColor.opacity(0.2),
                    lineWidth: lineWidth
                )
            
            Text("\(Int(progress * 100))%")
                .themedFont(name: .semiBold, size: textFontSize)
                .foregroundColor(foreGroundColor)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    progress != 0 ? foreGroundColor : Color.clear,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)
        }
    }
}

#Preview {
   CircularProgressView()
}


