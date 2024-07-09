//
//  CyclingActivity.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

class CyclingActivity: Identifiable, ObservableObject {
    @Published var id: UUID = UUID()
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var durationInMin: Int
    @Published var distanceInKm: Double
    @Published var averageSpeedInKMH: Double
    @Published var elevationAscendedInM: Double
    
    init(startDate: Date, endDate: Date, durationInMin: Int, distanceInKm: Double, averageSpeedInKMH: Double, elevationAscendedInM: Double) {
        self.startDate = startDate
        self.endDate = endDate
        self.durationInMin = durationInMin
        self.distanceInKm = distanceInKm
        self.averageSpeedInKMH = averageSpeedInKMH
        self.elevationAscendedInM = elevationAscendedInM
    }
}

extension CyclingActivity {
    
    static var preview: CyclingActivity {
        return .init(
            startDate: .now,
            endDate: .now,
            durationInMin: 34,
            distanceInKm: 12,
            averageSpeedInKMH: 21.4,
            elevationAscendedInM: 75.6
        )
    }
    
}
