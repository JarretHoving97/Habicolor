//
//  ChoosteHealthTemplateView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct ChoosteHealthTemplateView: View {
    
    let store: StoreOf<ChooseHealthTemplateFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.template) { viewStore in
            HStack(spacing: 10) {
                // icon
                viewStore.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(viewStore.color)

                Button {
              
                } label: {
                    ZStack {
                        Button {
                            viewStore.send(.didTapSelectTemplate)
                        }
                    label: {
                        
                        HStack {
                            Text(viewStore.title)
                                .foregroundStyle(viewStore.color)
                            Image(systemName: "chevron.down")
                                .padding(.bottom, -1)
                                .foregroundStyle(viewStore.color)
                            
                        }
                        
                        .padding(EdgeInsets(top: 4, leading: 20, bottom: 3, trailing: 20))
                        .themedFont(name: .bold, size: .small)
                        
                        .foregroundColor(.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(viewStore.color, lineWidth: 3)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ChoosteHealthTemplateView(
        store: Store(
            initialState: ChooseHealthTemplateFeature.State(
                template: .init(
                    template: .fysical(.distance(""))
                )
            ),
            reducer: {
                ChooseHealthTemplateFeature(
                 healthRequest: ReadHealthPermissionRequest(
                    options: []
                )
            )
            }
        )
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.4))
    
}
