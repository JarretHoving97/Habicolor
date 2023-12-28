//
//  NotificationView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 11/12/2023.
//

import SwiftUI

struct NotificationView: View {
    
    let reminder: Reminder
    
    var onDelete: (() -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Image.Icons.notificationOn
                    .foregroundStyle(Color.appTextColor)
                
                Text(reminder.time.formatToDateString(with: .time))
                    .themedFont(name: .bold, size: .title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.appTextColor)
                
                Spacer()
                
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }
            }
            
            HStack {
                Text(reminder.weekDaysString)
                    .themedFont(name: .regular, size: .small)
                    .foregroundStyle(Color.appTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(reminder.description)
                .themedFont(name: .regular, size: .subtitle)
                .foregroundStyle(Color.appTextColor.opacity(0.3))
                .lineLimit(2)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
    }
}

#Preview {
    NotificationView(
        reminder: Reminder(id: UUID(),
                           days: [.monday, .tuesday, .friday],
                           time: Date(),
                           title: "YNW",
                           description: ""),
        onDelete: {}
    )
}
