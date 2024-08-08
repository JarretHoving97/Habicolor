//
//  SelectWeekDaysView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct SelectWeekDaysView: View {
    let store: StoreOf<SelectWeekDaysFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                HStack(spacing: 10) {
                    ForEach(WeekDay.allCases, id: \.self) { weekday in
                        Button(action: {
                            viewStore.send(.didTapWeekDay(weekday))
                        }, label: {
                            WeekDayView(day: weekday, selected: viewStore.selectedWeekDays.contains(weekday))
                                .frame(
                                       width: max((geometry.size.width - 2 * 17 - 6 * 10) / 7, 0),
                                       height: max((geometry.size.width - 2 * 17 - 6 * 10) / 7, 0)
                                   )
                        })
                    }
                }
                .frame(height: 60)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
            }
        }
    }
}


#Preview {
    SelectWeekDaysView(
        store: Store(
            initialState: SelectWeekDaysFeature.State(selectedWeekDays: []),
            reducer: {SelectWeekDaysFeature()
            }
        )
    )
}
