//
//  SystemThemeObserver.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import SwiftUI

class SystemThemeObserver {
    
    static func getSystemTheme() -> ColorScheme? {
        let currentColorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? ColorScheme.dark : ColorScheme.light
        return currentColorScheme
    }
}
