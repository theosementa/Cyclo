//
//  HealthManager+BestEfforts+Extensions.swift
//  CycloStats
//
//  Created by Theo Sementa on 08/09/2024.
//

import Foundation

extension HealthManager {
    
    var elevationBestEfforts: [CyclingActivity] {
        return self.cyclingActivities
            .sorted(by: { $0.elevationAscendedInM > $1.elevationAscendedInM })
    }
    
    var distanceBestEfforts: [CyclingActivity] {
        return self.cyclingActivities
            .sorted(by: { $0.distanceInKm > $1.distanceInKm })
    }
    
    var averageSpeedBestEfforts: [CyclingActivity] {
        return self.cyclingActivities
            .sorted(by: { $0.averageSpeedInKMH > $1.averageSpeedInKMH })
    }
    
}
