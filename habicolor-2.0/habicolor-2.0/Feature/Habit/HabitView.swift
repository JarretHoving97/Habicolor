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
            
            Button {
                viewStore.send(.delegate(.didTapSelf(viewStore.habit)))
                
            } label: {
                ZStack {
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            VStack(spacing: 0) {
                                HStack(spacing: 5) {
                                    Circle()
                                        .tint(viewStore.habit.color)
                                        .frame(width: 10, height: 10, alignment: .center)
                                    
                                    Text(viewStore.habit.name)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .themedFont(name: .medium, size: .regular)
                                        .foregroundStyle(.appText)
                                }
                                Text(viewStore.habit.description)
                                    .lineLimit(3, reservesSpace: false)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .themedFont(name: .regular, size: .regular)
                                    .foregroundStyle(.appText)
                            }
                            
                            Button(action: { viewStore.send(.showEmojiesTapped, animation: .interactiveSpring)}, label: {
                                
                                if viewStore.selectedEmoji != nil {
                                    Image(systemName: "checkmark")
                                } else {
                                    Image(systemName: viewStore.collapsed ? "plus" : "minus")
                                }
                                
                            })
                            .frame(width: 50, height: 50)
                        }
                        
                        if !viewStore.collapsed {
                            HStack {
                                ForEach(Emoji.allCases, id: \.self) { emoji in
                                    Button(action: {
                                        viewStore.send(.didSelectEmoji(emoji), animation: .snappy)
                                    }, label: {
                                        ZStack {
                                            if emoji == viewStore.selectedEmoji {
                                                viewStore.habit.color
                                            }
                                            
                                            Text(emoji.icon)
                                                .font(.title)
                                        }
                                        .cornerRadius(20)
                                        .frame(width: 40, height: 40)
                                    })
                                }
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 4))
            }
            .opacity(viewStore.showAsCompleted ? 0.6 : 1.0)
            .task(id: viewStore.selectedEmoji) {
                
                guard !viewStore.collapsed else { return }
                
                do {
                    try await Task.sleep(seconds: 1.2)
                    await viewStore.send(.selectEmojiDebounced, animation: .easeOut).finish()
                } catch {
                    Log.error("error: \(String(describing: error))")
                }
            }
        }
        .clipShape(.rect(cornerSize: CGSize(width: 8, height: 8)))
    }
}

#Preview {
    HabitView(
        store: Store(
            initialState: HabitFeature.State(
                habit: Habit(
                    id: UUID(),
                    name: "Quit smoking",
                    weekGoal: 4,
                    description: "Smoking causes lots of health problems. I do need to see more text to see how it's layout properly",
                    color: .red,
                    notifications: [
                        Reminder(
                            id: UUID(),
                            days: [
                                .monday,
                                .tuesday,
                                .wednessday,
                                .thursday,
                                .friday,
                                .saturday,
                                .sunday
                            ],
                            time: Date(),
                            title: "Quit smoking!",
                            description: "You've mad this mourning. Good job!"
                        )
                    ]
                )
            ),
            reducer: { HabitFeature() }
        )
    )
}
