//
//  ContributionView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct ContributionView: View {
    
    let store: StoreOf<ContributionFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            ZStack {
                Color.cardColor
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(viewStore.previousWeeks.reversed(), id: \.self) { week in
                                let contributionWeek = week.map({Contribution(log: HabitLog.random(for: $0), date: $0)})
                                ContributionRow(contributions: contributionWeek)
                            }
                        }
                    }
                }
                .padding()
            }
    
            .onAppear {
                viewStore.send(.generateCurrentWeek)
                viewStore.send(.generatePreviousWeeks)
            }
        }
    }
    
    @ViewBuilder func weekLabels() -> some View {
        VStack(spacing: 4) {
            Spacer(minLength: 10) // month labels spacing
            ForEach((1...7), id: \.self) { day in
                let day = DateComponents(weekday: day)
                ZStack {
                    Text(getLabelForWeekDay(dayComponents: day))
                        .frame(minWidth: 20, minHeight: 20, alignment: .center)
//                            .themedFont(name: .regular, size: .small)
                        .foregroundColor(.appTextColor)
                }
            }
        }
        .frame(minWidth: 20)
    }
    
    func getLabelForWeekDay(dayComponents: DateComponents?) -> String {
        
        if let day = dayComponents?.weekday {
            
            switch day {
            case 3:
                return "Wed" // TODO: Translations
            case 4:
                return "Thu" // TODO: Translations
            case 5:
                return "Fri" // TODO: Tanslations
            default:
                return " "
            }
        } else {
            return " "
        }
    }
}

#Preview {
    ContributionView(
        store: Store(
            initialState: ContributionFeature.State(logs: HabitLog.generateYear()),
            reducer: {ContributionFeature()}
        )
    )
}
