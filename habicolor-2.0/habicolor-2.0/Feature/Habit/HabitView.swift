//
//  HabitView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitView: View {
    
    let store: StoreOf<HabitFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            ZStack {
                
                Color.gray
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Text(viewStore.habit.name)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Spacer()
                        

                    }
                 
                    HStack {
                        ForEach(viewStore.habit.weekHistory, id: \.self) { log in
                            viewStore.habit.color
                                .opacity(0.4)
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
            .clipShape(.rect(cornerSize: CGSize(width: 8, height: 8)))
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
 
        }
    }
}

#Preview {
    HabitView(
        store: Store(
            initialState: HabitFeature.State(
                habit: Habit(name: "Quit smoking"
                             , color: .red,
                             weekHistory: [0, 2, 4, 5, 2, 4,3,]
                            )
            ),
            reducer: { HabitFeature() }
        )
    )
}
