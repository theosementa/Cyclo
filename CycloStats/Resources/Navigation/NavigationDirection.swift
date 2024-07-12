//
//  NavigationDirection.swift
//  Krabs
//
//  Created by Theo Sementa on 05/12/2023.
//

import Foundation
import SwiftUI


enum NavigationDirection: Identifiable {
        
    case home
    case activities
    case progress
    
    case detail(activity: CyclingActivity)

    var id: String {
        switch self {
        case .home:
            return "home"
        case .activities:
            return "activities"
        case .progress:
            return "progress"
            
        case .detail(_):
            return "detail"
        }
    }
}

extension NavigationDirection: Equatable {
    static func == (lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home),
            (.activities, .activities),
            (.progress, .progress),
            
            (.detail(_), .detail(_)):
            return true

        default:
            return false
        }
    }
}

extension NavigationDirection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
