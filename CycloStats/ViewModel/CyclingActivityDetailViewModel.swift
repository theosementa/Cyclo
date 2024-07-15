//
//  CyclingActivityDetailViewModel.swift
//  CycloStats
//
//  Created by KaayZenn on 13/07/2024.
//

import Foundation
import MapKit

final class CyclingActivityDetailViewModel: ObservableObject {
    
    @Published var locations: [CLLocation] = []
    
    @Published var showFullMap: Bool = false
    
}

extension CyclingActivityDetailViewModel {
    
    @MainActor
    func setupDetailView(activity: CyclingActivity, healthManager: HealthManager) async {
        if let workout = activity.originalWorkout, let routes = await healthManager.getWorkoutRoute(workout: workout) {
            for route in routes {
                let location = await healthManager.getLocationDataForRoute(givenRoute: route)
                if activity.maxSpeedInKMH == 0 {
                    let maxSpeed = await healthManager.fetchMaxSpeed(givenRoute: route)
                    activity.maxSpeedInKMH = maxSpeed
                }
                self.locations.append(contentsOf: location)
            }
        }
    }
    
}
