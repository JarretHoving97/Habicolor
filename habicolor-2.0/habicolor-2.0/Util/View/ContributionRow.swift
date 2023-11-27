//
//  ContributionRow.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/11/2023.
//

import SwiftUI

struct ContributionRow: View {
    
    var color: Color = .secondaryColor
    var contributions: [Contribution]
    
    var body: some View {
        VStack(spacing: 4) {
            containsNewMonth()
                .frame(width: 24)
            VStack(spacing: 4) {
                ForEach(contributions, id: \.self) { contribution in
                    
                    ContributionPixel(color: contribution.log?.color(color) ?? .pixelEmptyColor)
                        .cornerRadius(2)
                        .frame(minWidth: 24, minHeight: 24)
                    
                }
                .frame(width: 24)
            }
        }
        .onAppear {
            guard let filled = contributions.filter({$0.log != nil}).first else { return }
            Log.debug(filled.log!.emoji.rawValue.description)
        }
    }
    
    @ViewBuilder private func containsNewMonth() -> some View {
        let weekDates = contributions.map { $0.date.get(.day)}
        let month = contributions.map({$0.date}).last?.month ?? ""
        
        
        if weekDates.contains(1) {
            Text(month)
                .themedFont(name: .regular, size: .small)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .scaledToFill()
                .foregroundColor(Color.appTextColor)
        } else {
            Text(" ")
                .themedFont(name: .regular, size: .small)
                .minimumScaleFactor(0.5)
                .scaledToFit()
                .foregroundColor(Color.appTextColor)
        }
    }
}
#Preview {
    let date = Date()
    return ContributionRow(contributions: [Contribution(log: HabitLog.random(for: date), date: date)])

}
