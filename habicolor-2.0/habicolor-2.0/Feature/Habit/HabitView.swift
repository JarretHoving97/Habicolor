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
                VStack(spacing: 6) {
                    HStack(spacing: 20) {
                        VStack {
                            Text(viewStore.habit.name)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .themedFont(name: .medium, size: .regular)
                                .foregroundStyle(.appText)
                            
                            
                            Text(viewStore.habit.description)
                                .lineLimit(3, reservesSpace: false)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .regular, size: .regular)
                                .foregroundStyle(.appText)
                        }
                        
                        Button(action: {viewStore.send(.showEmojiesTapped, animation: .interactiveSpring)}, label: {
                            
                            Image(systemName: viewStore.collapsed ? "chevron.down" : "chevron.up")
                        })
                    }

                    if !viewStore.collapsed {
                        HStack {
                            ForEach(["😓", "🙁", "😐", "😄", "🤩"], id: \.self) { emoji in
                                
                                ZStack {
       
                                    Text(emoji)
                                        .font(.title)
                                }
                            }
                            
                            Spacer()
                        }

                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
        }
        .clipShape(.rect(cornerSize: CGSize(width: 8, height: 8)))
    }
}

#Preview {
    HabitView(
        store: Store(
            initialState: HabitFeature.State(
                habit: Habit(name: "Quit smoking", description: "Smoking causes lots of health problems. I do need to see more text to see how it's layout properly"
                             , color: .red,
                             weekHistory: [0, 2, 4, 5, 2, 4,3,]
                            )
            ),
            reducer: { HabitFeature() }
        )
    )
}
