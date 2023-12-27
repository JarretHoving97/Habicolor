//
//  habicolor_2_0App.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct habicolor_2_0App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppFeatureView(
                store: Store(
                    initialState: AppFeature.State(
                        preferredColorScheme: getInitialColorScheme()
                    ),
                    reducer: { AppFeature() }
                )
            )
        }
    }
}

extension habicolor_2_0App {
    func getInitialColorScheme() -> ColorScheme? {
        let userPrefferedColorScheme =  AppSettingsProvider.shared.userPrefferedColorScheme
        
        if userPrefferedColorScheme == "Dark" {
            return .dark
        } else if userPrefferedColorScheme == "Light" {
            return .light
        } else {
            return nil
        }
    }
}
