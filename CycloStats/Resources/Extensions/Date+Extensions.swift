//
//  Date+Extensions.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

extension Date {
    static var startOfDay: Date {
        return Calendar.current.startOfDay(for: .now)
    }
    
    static var firstDayOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.startOfDay(for: calendar.date(from: components) ?? .now)
    }
    
    static var firstDayOfWeek: Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? .now
        return calendar.startOfDay(for: startOfWeek)
    }

    static var firstDayOfYear: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        return calendar.startOfDay(for: calendar.date(from: components) ?? .now)
    }
}
