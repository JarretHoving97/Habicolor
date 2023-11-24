//
//  WeekDayView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/10/2023.
//

import SwiftUI

struct WeekDayView: View {
    
    var weekday: WeekDay
    var selected: Bool
    
    init(day: WeekDay, selected: Bool) {
        self.weekday = day
        self.selected = selected
    }
    
    var body: some View {
        
        ZStack {
            Color.cardBackground
            Text(weekday.localizedString.prefix(2))
                .themedFont(name: .bold, size: .regular)
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primaryColor, lineWidth:  selected ? 3 : 0)
        )
        .frame(maxWidth: 80, maxHeight: 80)
    }
}

#Preview {
    return WeekDayView(day: .monday, selected: false)
}
