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
    var body: some Scene {
        WindowGroup {
            AppFeatureView(
                store: Store(
                    initialState: AppFeature.State(),
                    reducer: { AppFeature() }
                )
            )
        }
    }
}
