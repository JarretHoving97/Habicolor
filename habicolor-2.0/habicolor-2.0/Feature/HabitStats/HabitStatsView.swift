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
   
                HStack(spacing: 27){
                    VStack {
                        ZStack {
                            viewStore.color
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .opacity(
                                    viewStore.averageScore == 0 ? 0.2:
                                    .alpha(for: Emoji(rawValue: viewStore.averageScore)!)
                                )
                            
                            Text(Emoji(rawValue: viewStore.averageScore)?.icon ?? "")
                                .themedFont(name: .regular, size: .large)
                        }
                
                    }
                    CircularProgressView(
                        lineWidth: 14,
                        progress: viewStore.completionRate,
                        foreGroundColor: viewStore.color,
                        textFontSize: .large
                    )
                    .frame(minWidth: 150,
                           maxWidth: 200,
                           minHeight: 150,
                           maxHeight: 200,
                           alignment: .leading
                    )
               
                    VStack(spacing: 20) {
                        
                        VStack {
                            CircularProgressView(
                                lineWidth: 8,
                                progress: Double(viewStore.averageScore) / Double(5),
                                foreGroundColor: viewStore.color,
                                textFontSize: .small
                            )
                            .frame(minWidth: 30,
                                   maxWidth: 50,
                                   minHeight: 30,
                                   maxHeight: 50,
                                   alignment: .center
                            )
                        }
                    }
                    .frame(alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 10)
            
            .task {
                try? await Task.sleep(seconds: 0.4)
                viewStore.send(.loadWeeksAverageScore, animation: .easeIn)
                viewStore.send(.loadWeeksCompletionRate, animation: .easeIn)
            }
        }
    }
}

#Preview {
    
    HabitStatsView(
        store: Store(
            initialState: HabitStatsFeature.State(
                
                weekgoal: 7,
                color: .purple,
                habit: UUID()
            ),
            reducer: { HabitStatsFeature(client: .live) }
        )
    )
}
