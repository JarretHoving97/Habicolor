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
            
            VStack(spacing: 20) {
                
                CircularProgressView(
                    lineWidth: 14,
                    progress: viewStore.averageScore / 10, 
                    foreGroundColor: viewStore.color,
                    textFontSize: .large
                )
                .frame(minWidth: 150,
                       maxWidth: 200,
                       minHeight: 150,
                       maxHeight: 200,
                       alignment: .center
                )
                HStack(spacing: 17) {
                    ZStack {
                        Color.cardColor
                            .cornerRadius(8)
                        
                        VStack {
                            Text("Week goal") // TODO: Translations
                                .themedFont(name: .bold, size: .regular)
                            Text(viewStore.weekGoal.description)
                        }
                    }
                    
                    ZStack {
                        Color.cardColor
                            .cornerRadius(8)
                        
                        VStack { // Translations
                            Text("Logs missed")
                                .themedFont(name: .bold, size: .regular)
                            Text(viewStore.missed.description)
                        }
                    }
                }
                .frame(height: 80)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 10)
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
                weekgoal: 7,
                color: .purple
            ),
            reducer: { HabitStatsFeature() }
        )
    )
}
