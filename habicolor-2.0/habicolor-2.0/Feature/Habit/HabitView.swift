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
                                Image.Icons.check
                            } else {
                                if viewStore.collapsed {
                                    Image.Icons.plus
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                } else {
                                    Image(systemName: "minus")
                                }
                                
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
                    
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 4))
            }
            .opacity(viewStore.showAsCompleted ? 0.6 : 1.0)
            
            .task {
                viewStore.send(.showDidLogToday)
            }
            
            .task(id: viewStore.selectedEmoji) {
                guard !viewStore.collapsed else { return }
                
                do {
                    try await Task.sleep(seconds: 1.2)
                    await viewStore.send(.selectEmojiDebounced, animation: .easeOut).finish()
                } catch {
                    Log.error("error: \(String(describing: error))")
                }
            }
            .background(Color.appBackgroundColor)
            .clipShape(.rect(cornerSize: CGSize(width: 8, height: 8)))
          
            .shadow(color: .shadowColor, radius: 25, x: 0, y: 25)
            .contextMenu {
                Button {
                    viewStore.send(.didTapLogForDate)
                } label: {
                    Label(trans("add_passed_day_log"), systemImage: "clock.arrow.circlepath")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
            
            .sheet(
                store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                state: /HabitFeature.Destination.State.habitLogdateFeature,
                action: HabitFeature.Destination.Action.habitLogdateFeature
            ) { store in
                HabitLogDateView(store: store)
            }
        }
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
                    description: "ONE LINE",
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
            reducer: { HabitFeature(client: .live) }
        )
    )
}
