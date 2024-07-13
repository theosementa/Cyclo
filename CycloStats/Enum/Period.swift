//
//  Period.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import Foundation

enum Period: CaseIterable {
    case week, month, year, total
    
    var name: String {
        switch self {
        case .week:     return Word.Period.week
        case .month:    return Word.Period.month
        case .year:     return Word.Period.year
        case .total:    return Word.Period.total
        }
    }
}

enum PeriodStatus {
    case start, end
}
