//
//  HabitTemplateView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import SwiftUI
import ComposableArchitecture


struct HabitTemplateView: View {
    
    let store: StoreOf<HabitTemplateFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 17) {
                    ForEach(viewStore.templates, id: \.self) { template in
                        
                        ZStack {
                            template.color.opacity(0.4)
                                .frame(height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 25), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.appTextColor, lineWidth: template == viewStore.selectedTemplate ? 3 : 0) // Set the color and width of the border
                                )
                            
                            Text(template.name)
                                .frame(alignment: .center)
                                .padding(10)
                                .foregroundStyle(.white)
                                .themedFont(name: .bold, size: .regular)
                        }
                        .onTapGesture {
                            viewStore.send(.didSelectTamplate(template), animation: .easeIn)
                        }
                    }
                }
                .frame(height: 50)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
            }
            
        }
        
    }
}

#Preview {
    HabitTemplateView(store: Store(
        initialState: HabitTemplateFeature.State(
            templates: TemplateModel.templates,
            selectedTemplate: nil),
        reducer: { HabitTemplateFeature() }
    )
    )
}
