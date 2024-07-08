//
//  CyclingActivity.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

class CyclingActivity: Identifiable {
    var id: UUID = UUID()
    var startDate: Date
    var endDate: Date
    var durationInMin: Int
    var distanceInKm: Double
    var averageSpeedInKMH: Double
    var elevationAscendedInM: Double
    
    init(startDate: Date, endDate: Date, durationInMin: Int, distanceInKm: Double, averageSpeedInKMH: Double, elevationAscendedInM: Double) {
        self.startDate = startDate
        self.endDate = endDate
        self.durationInMin = durationInMin
        self.distanceInKm = distanceInKm
        self.averageSpeedInKMH = averageSpeedInKMH
        self.elevationAscendedInM = elevationAscendedInM
    }
}
