//
//  Notification.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import Foundation

struct Notification: Equatable, Hashable {
    let id = UUID()
    var days: [WeekDay]
    var time: Date
    var title: String
    var description: String
}
