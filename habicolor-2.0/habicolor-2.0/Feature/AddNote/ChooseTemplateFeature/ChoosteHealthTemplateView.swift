//
//  ChoosteHealthTemplateView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct HealthTemplateButtonView: View {
    
    let store: StoreOf<HealthTemplateButtonFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.template) { viewStore in
            HStack(spacing: 10) {
                // icon
                viewStore.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(viewStore.imageTint)
            
                
                ZStack {
                    Button {
                        viewStore.send(.didTapSelectTemplate)
                    }
                    
                label: {
                    
                    HStack {
                        Text(viewStore.title)
                            .foregroundStyle(viewStore.textTint)
                        
                        Image(systemName: "chevron.down")
                            .renderingMode(.template)
                            .padding(.bottom, -1)
                            .foregroundStyle(viewStore.textTint)
                    }
                    
                    .padding(EdgeInsets(top: 4, leading: 20, bottom: 3, trailing: 20))
                    .themedFont(name: .bold, size: .small)
                    
                    .foregroundColor(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(viewStore.textTint, lineWidth: 3)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                    
                }
            }
        }
    }
}

#Preview {
    HealthTemplateButtonView(
        store: Store(
            initialState: HealthTemplateButtonFeature.State(template: .init(template: .vital(.bpm("64 BPM")))),
            reducer: {HealthTemplateButtonFeature()}
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.4))
    
}
