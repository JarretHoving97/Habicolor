//
//  UIColor+Extension.swift
//  PixHabit
//
//  Created by Jarret Hoving on 01/10/2022.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: 1.0
        )
    }

    func hexStringFromColor() -> String {
        let uiColor = UIColor(self)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let redInt = lround(Double(red) * 255)
            let greenInt = lround(Double(green) * 255)
            let blueInt = lround(Double(blue) * 255)

            return String(format: "#%02lX%02lX%02lX", redInt, greenInt, blueInt)
    }
}

