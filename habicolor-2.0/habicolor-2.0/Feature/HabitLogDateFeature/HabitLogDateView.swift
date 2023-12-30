//
//  HabitLogDateView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitLogDateView: View {
    
    let store: StoreOf<HabitLogDateFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                
                DatePicker("Datum", selection: viewStore.binding(
                    get: \.date,
                    send: HabitLogDateFeature.Action.setLogDate
                ), displayedComponents: .date
                )
                
                .themedFont(name: .medium, size: .regular)
                
                .pickerStyle(.menu)
                .padding(.leading, 17)
                .padding(.trailing, 17)
                .padding(.bottom, 10)
                
                HStack {
                    ForEach(Emoji.allCases, id: \.self) { emoji in
                        Button(action: {
                            viewStore.send(.didLogForDate(emoji), animation: .snappy)
                            
                        }, label: {
                            ZStack {
                                if emoji == viewStore.emoji {
                                    viewStore.habit.color
                                }
                                
                                Text(emoji.icon)
                                    .font(.title)
                            }
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                        })
                    }
                }
                .padding(.leading, 17)
                .padding(.trailing, 17)
                
                Button(action: {
                    viewStore.send(.saveLogAndDismiss)
                }, label: {
                    ButtonView(title: "Log")
                })
                .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
                .frame(height: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackgroundColor)
        }
    }
}

#Preview {
    HabitLogDateView(store: Store(
        initialState: HabitLogDateFeature.State(habit: .example),
        reducer: {HabitLogDateFeature(client: .live) }
    )
    )
}
