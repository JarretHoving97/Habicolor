//
//  Font+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/10/2023.
//

import Foundation
import UIKit
import SwiftUI

struct ScaledFont: ViewModifier {
    
    enum ThemeFont: String {
        
        case regular = "Poppins-Regular"
        
        case bold = "Poppins-Bold"
        
        case semiBold = "Poppins-SemiBold"
        
        /// BalooBhai2-ExtraBold
        case extraBold = "Poppins-ExtraBold"
        
        /// BalooBhai2-medium
        case medium = "Poppins-Medium"
    }
    
    enum ThemeFontSize: CGFloat {
        /// 8 pt
        case extraSmall = 8.0
        /// 11 pt
        case tabbarItem = 11.0
        /// 12 pt
        case small = 12.0
        /// 13 pt
        case legal = 13.0
        /// 14 pt
        case subtitle = 14.0
        /// 16 pt
        case regular = 16.0
        /// 18 pt
        case title = 18.0
        /// 28 pt
        case numberpad = 28.0
        /// 34 pt
        case large = 34.0
        /// 24 pt
        case largeValutaSub = 24
        /// 56 pt
        case largeValuta = 56
        // 9pt
        case subLabel = 9
        
        case bigEmoji1 = 64
        
        // big emoji
        case bigEmoji = 72
    }
    
    var name: ThemeFont
    var size: ThemeFontSize
    
    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size.rawValue)
        return content.font(.custom(name.rawValue, size: scaledSize))
    }
}

extension View {
    func themedFont(name: ScaledFont.ThemeFont, size: ScaledFont.ThemeFontSize) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}

