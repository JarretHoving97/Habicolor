//
//  CompletionRateCalculator.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 23/12/2023.
//

import Foundation


struct CompletionRateCalculator {
    
    func calculateCompletionRate(habitLogs: [HabitLog]) -> Double {
        
        guard let startDate = habitLogs.first?.logDate, let endDate = habitLogs.last?.logDate else { return 0.0}
        
        let completedDays = Set(habitLogs
            .filter { $0.logDate >= startDate && $0.logDate <= endDate && $0.score > 0 }
            .map { $0.logDate })

        let totalDays = Set(getAllDaysBetween(startDate: startDate, endDate: endDate))

        guard !totalDays.isEmpty else {
            return 0.0
        }

        let completionRate = Double(completedDays.count) / Double(totalDays.count) * 100.0
        return completionRate
    }
    
    
    func calculateCompletionRateWithWeeklyGoal(habitLogs: [HabitLog], weekGoal: Int) -> Double {
        guard let startDate = habitLogs.first?.logDate, let endDate = habitLogs.last?.logDate else { return 0.0 }

        let completedDays = Set(habitLogs
            .filter { $0.logDate >= startDate && $0.logDate <= endDate && $0.score > 0 }
            .map { $0.logDate })

        let totalDays = getAllDaysBetween(startDate: startDate, endDate: endDate)

        guard !totalDays.isEmpty else {
            return 0.0
        }

        let totalWeeks = Double(Calendar.current.dateComponents([.weekOfYear], from: startDate, to: endDate).weekOfYear ?? 1)

        let expectedCompletions = weekGoal * Int(totalWeeks)

        let completionRate = min(Double(completedDays.count) / Double(expectedCompletions), 1.0) * 100.0
        return completionRate
    }

    private func getAllDaysBetween(startDate: Date, endDate: Date) -> [Date] {
        var allDays: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            allDays.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return allDays
    }
}
