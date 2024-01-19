//
//  HearthBpmView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct HearthBpmView: View {
    let store: StoreOf<HeathBpmFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.currentBpm) { viewStore in
            
            HStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 22.22)
                    .foregroundStyle(Color("vital_heart_color"))
                
                Text("\(viewStore.state) SPM") // TODO: Translations
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .themedFont(name: .semiBold, size: .largeValutaSub)
            }
            
            .padding()
            .background(Color("health_vital_template"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
         
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            
            .task {
                viewStore.send(.startLoadingBpm)
            }
        }
    }
}

#Preview {
    
    struct ExampleHeartbeat: CurrentHearthBPMReadable {
        func read() async throws -> String {
            return "84"
        }
    }
    
   return HearthBpmView(
        store: Store(
            initialState: HeathBpmFeature.State(),
            reducer: { HeathBpmFeature(bpmReadable: ExampleHeartbeat()) }
        )
        
    )
}
