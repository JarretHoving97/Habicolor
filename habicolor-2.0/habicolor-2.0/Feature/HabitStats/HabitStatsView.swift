//
//  HabitStatsView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitStatsView: View {
    
    let store: StoreOf<HabitStatsFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            
            HStack(spacing: 10) {
                
                
                VStack {
                    Text("Score")
                        .themedFont(name: .bold, size: .small)
                    
                    CircularProgressView(
                        lineWidth: 8,
                        progress: viewStore.averageScore / 10,
                        textFontSize: .title
                    )
                    
                    .frame(width: 90, height: 90)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            .onAppear {
                Task {
                    try? await Task.sleep(seconds: 0.4)
                    viewStore.send(.calculateAverageScore, animation: .bouncy)
                }
                
            }
        }
    }
}

#Preview {
    HabitStatsView(
        store: Store(
            initialState: HabitStatsFeature.State(
                logs: HabitLog.generateYear(),
                weekgoal: 7
            ),
            reducer: { HabitStatsFeature() }
        )
    )
}
