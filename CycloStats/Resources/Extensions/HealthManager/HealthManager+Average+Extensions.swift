//
//  HealthManager+Average+Extensions.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import Foundation

// MARK: - Day
extension HealthManager {
    var averageDistancePerDay: Double {
        guard activitiesForCharts.count != 0 else { return 0 }
        let totalDistance = activitiesForCharts.reduce(0) { $0 + $1.distanceInKm }
        return totalDistance / Double(activitiesForCharts.count)
    }
    
    var averageElevationPerDay: Double {
        guard activitiesForCharts.count != 0 else { return 0 }
        let totalElevation = activitiesForCharts.reduce(0) { $0 + $1.elevationInM }
        return totalElevation / Double(activitiesForCharts.count)
    }
    
    var averageHeartRatePerDay: Int {
        guard activitiesForCharts.count != 0 else { return 0 }
        let totalHearthRate = activitiesForCharts.reduce(0) { $0 + $1.averageHeartRate }
        return totalHearthRate / activitiesForCharts.count
    }
}

extension HealthManager {
    var averageDistanceInKm: Double {
        guard filteredCyclingActivities.count != 0 else { return 0 }
        return totalDistance / Double(filteredCyclingActivities.count)
    }
    
    var averageElevationInM: Double {
        guard filteredCyclingActivities.count != 0 else { return 0 }
        return totalElevationAscended / Double(filteredCyclingActivities.count)
    }
}
