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
            ZStack {
                if viewStore.state != nil {
                    Button {
                        viewStore.send(.delegate(.didTapSelf))
                    } label: {
                        HStack(spacing: 17) {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 24, height: 22.22)
                                .foregroundStyle(Color("vital_heart_color"))
                            
                            VStack(spacing: -10){
                                Text("\(viewStore.state?.data ?? "") BPM") // TODO: Translations
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .themedFont(name: .semiBold, size: .largeValutaSub)
                          
                                Text(viewStore.state?.date.formatToDateString(with: .time) ?? "")
                                        .frame(maxWidth: .infinity, maxHeight: 10, alignment: .trailing)
                                        .themedFont(name: .regular, size: .small)
                                        .opacity(0.3)
                            }
                        }
                        .padding(EdgeInsets(top: 14, leading: 21, bottom: 14, trailing: 21))
                        .background(Color("health_vital_template"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .tint(.appText)
                }
            }
            .task {
                viewStore.send(.startLoadingBpm)
            }
        }
    }
}

#Preview {
    
    struct ExampleHeartbeat: CurrentHearthBPMReadable {
        func read() async throws -> Bpm {
            return Bpm(data: "84", date: Date())
        }
    }
    
    return HearthBpmView(
        store: Store(
            initialState: HeathBpmFeature.State(),
            reducer: { HeathBpmFeature(bpmReadable: ExampleHeartbeat()) }
        )
        
    )
}
