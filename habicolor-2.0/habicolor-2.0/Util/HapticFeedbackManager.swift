//
//  HapticFeedbackManager.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/10/2023.
//

import SwiftUI

class BatteryInfo {
    
    static var isLowPowerMode: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
}


class HapticFeedbackManager {
    
    static private var shoudldPerformHapticFeedback: Bool {
        return !BatteryInfo.isLowPowerMode || BatteryInfo.batteryLevel > 2
    }
    
    static private var hapticFeedbackEnabled: Bool {
        AppSettingsProvider.shared.hapticFeedbackEnabled
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticFeedbackEnabled && shoudldPerformHapticFeedback else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    static func selection() {
        guard hapticFeedbackEnabled && shoudldPerformHapticFeedback  else { return }
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard hapticFeedbackEnabled && shoudldPerformHapticFeedback else { return }
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(type)
    }
}
