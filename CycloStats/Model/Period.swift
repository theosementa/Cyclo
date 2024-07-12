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
        case .week:     return "Semaine"
        case .month:    return "Mois"
        case .year:     return "Année"
        case .total:    return "Total"
        }
    }
}

enum PeriodStatus {
    case start, end
}
