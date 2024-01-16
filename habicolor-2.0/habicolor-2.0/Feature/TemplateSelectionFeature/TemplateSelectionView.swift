//
//  ChooseTemplateView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct TemplateSelectionView: View {
    
    let store: StoreOf<TemplateSelectionFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            Text("Show all")
        }
    }
}

#Preview {
    TemplateSelectionView(
        store: Store(
            initialState: TemplateSelectionFeature.State(),
            reducer: { TemplateSelectionFeature() }
        )
    )
}
