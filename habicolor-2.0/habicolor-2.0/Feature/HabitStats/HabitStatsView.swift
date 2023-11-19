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
            GeometryReader { geo in
                HStack(spacing: 20) {
                    CircularProgressView(
                        lineWidth: 14,
                        progress: viewStore.averageScore / 10,
                        textFontSize: .large
                    )
                    .frame(width: (geo.size.width / 2) - 32, height:  geo.size.width / 2)
           
     
                    VStack {
                        ZStack {
                            Color.cardColor
                                .cornerRadius(8)
                            
                            
                            VStack {
                                Text("Week goal") // TODO: Translations
                                    .themedFont(name: .bold, size: .small)
                                Text(viewStore.weekGoal.description)
                            }
                        }
                    
                        ZStack {
                            Color.cardColor
                                .cornerRadius(8)
                      
                            VStack { // Translations
                                Text("Logs missed")
                                    .themedFont(name: .bold, size: .small)
                                Text(viewStore.missed.description)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(height: geo.size.width / 2)
               
                 
                }
                
//                .frame(maxWidth: .infinity, maxHeight: 160, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 17 + 5 /* added correction */, bottom: 10, trailing: 17))
            }
     
            
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
