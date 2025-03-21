//
//  AppSettingsProvider.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/12/2023.
//

import Foundation

fileprivate extension String {
    static let colorSchemeKey = "nl.habicolor.colorscheme"
    static let hapticFeedbackEnableKey = "nl.habicolor.haptic.feedback.enabled"
    static let didDeleteHabitExample = "nl.habicolor.did.delete.example"
}


class AppSettingsProvider {
    
    static let shared = AppSettingsProvider()
    
    var userPrefferedColorScheme: String {
        get { UserDefaults.standard.string(forKey: .colorSchemeKey) ?? "System" }
        set { UserDefaults.standard.setValue(newValue, forKey: .colorSchemeKey) }
    }
    
    var hapticFeedbackEnabled: Bool {
        get { UserDefaults.standard.value(forKey: .hapticFeedbackEnableKey) as? Bool ?? true}
        set { UserDefaults.standard.setValue(newValue, forKey: .hapticFeedbackEnableKey) }
    }
    
    var didDeleteExample: Bool {
        get { UserDefaults.standard.value(forKey: .didDeleteHabitExample) as? Bool ?? false}
        set { UserDefaults.standard.setValue(newValue, forKey: .didDeleteHabitExample) }
    }
}
