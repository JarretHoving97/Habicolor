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
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 2) {
                            
                            HearthBpmView(
                                store: self.store.scope(
                                    state: \.currentBpm,
                                    action: TemplateSelectionFeature.Action.cuurentBpm
                                )
                            )
                            .frame(height: 60)
                        }
                        
                    }
                    .padding(17)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .navigationTitle("Choose template")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color.appBackgroundColor)
            
        }
    }
}

#Preview {
    NavigationStack {
        TemplateSelectionView(
            store: Store(
                initialState: TemplateSelectionFeature.State(),
                reducer: { TemplateSelectionFeature() }
            )
        )
    }
}
