//
//  Date+Extensions.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var dayMonthNumeric: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var dayMonthAbbreviated: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd MMM"
        formatter.locale = Locale.current
        return formatter.string(from: self).replacingOccurrences(of: ".", with: "").capitalized
    }
    
    var monthYearFull: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: self).capitalized
    }
    
    static var iPhoneReleaseDate: Date? {
        var components = DateComponents()
        components.year = 2007
        components.month = 6
        components.day = 29
        components.hour = 9
        components.minute = 41
        components.timeZone = TimeZone(abbreviation: "PST") // Heure du Pacifique (California)
        
        return Calendar.current.date(from: components)
    }
    
}

// MARK: - Week
extension Date {
    
    var startOfWeek: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)
    }
    
    var endOfWeek: Date? {
        let calendar = Calendar.current
        guard let startOfWeek = self.startOfWeek else { return nil }
        return calendar.date(byAdding: DateComponents(day: 7, second: -1), to: startOfWeek)
    }
    
    var oneWeekAgo: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self)!
    }

    var inOneWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self)!
    }
    
}

// MARK: - Month
extension Date {
    
    var startOfMonth: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }
    
    var endOfMonth: Date? {
        let calendar = Calendar.current
        guard let startOfMonth = self.startOfMonth else { return nil }
        return calendar.date(byAdding: DateComponents(month: 1, second: -1), to: startOfMonth)
    }
    
    var oneMonthAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    var inOneMonth: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
}

// MARK: - Year
extension Date {
    
    var startOfYear: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components)
    }
    
    var endOfYear: Date? {
        let calendar = Calendar.current
        guard let startOfYear = self.startOfYear else { return nil }
        return calendar.date(byAdding: DateComponents(year: 1, second: -1), to: startOfYear)
    }
    
    var inOneYear: Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)!
    }
    
    var oneYearAgo: Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
}

// MARK: - Custom with Period
extension Date {
    
    func newDateByPeriodInPast(_ period: Period, _ status: PeriodStatus) -> Date {
        let isStart = status == .start
        switch period {
        case .week:
            return isStart ? (self.oneWeekAgo.startOfWeek ?? .now) : (self.oneWeekAgo.endOfWeek ?? .now)
        case .month:
            return isStart ? (self.oneMonthAgo.startOfMonth ?? .now) : (self.oneMonthAgo.endOfMonth ?? .now)
        case .year:
            return isStart ? (self.oneYearAgo.startOfYear ?? .now) : (self.oneYearAgo.endOfYear ?? .now)
        case .total:
            return Date.iPhoneReleaseDate ?? .now
        }
    }
    
    func newDateByPeriodInFuture(_ period: Period, _ status: PeriodStatus) -> Date {
        let isStart = status == .start
        switch period {
        case .week:
            return isStart ? (self.inOneWeek.startOfWeek ?? .now) : (self.inOneWeek.endOfWeek ?? .now)
        case .month:
            return isStart ? (self.inOneMonth.startOfMonth ?? .now) : (self.inOneMonth.endOfMonth ?? .now)
        case .year:
            return isStart ? (self.inOneYear.startOfYear ?? .now) : (self.inOneYear.endOfYear ?? .now)
        case .total:
            return .now
        }
    }
    
}

