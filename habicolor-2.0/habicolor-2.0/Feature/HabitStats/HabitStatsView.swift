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
                CircularProgressView(
                    lineWidth: 12,
                    progress: viewStore.averageScore / 10,
                    textFontSize: .largeValutaSub
                )
                .frame(width: 129, height: 120)
 
                VStack {
                    ZStack {
                        Color.cardColor
                            .cornerRadius(8)
                 
                        
                        VStack {
                            Text("Week goal")
                                .themedFont(name: .bold, size: .small)
                            Text(viewStore.weekGoal.description)
                        }
                    }
                
                    ZStack {
                        Color.cardColor
                            .cornerRadius(8)
                  
                        VStack {
                            Text("Logs missed")
                                .themedFont(name: .bold, size: .small)
                            Text(viewStore.missed.description)
                        }
                    }
                }
                .frame(height: 120)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17))
            
            .onAppear {
                Task {
                    try? await Task.sleep(seconds: 0.4)
                    viewStore.send(.calculateAverageScore, animation: .bouncy)
                    viewStore.send(.scanMissedRegistrations)
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
