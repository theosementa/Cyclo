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
    @Published var heartRates: [HeartRateEntry] = []
    @Published var showFullMap: Bool = false
}

extension CyclingActivityDetailViewModel {
    
    @MainActor
    func setupDetailView(activity: CyclingActivity, healthManager: HealthManager) async {
        if let workout = activity.originalWorkout, let routes = await healthManager.getWorkoutRoute(workout: workout) {
            for route in routes {
                let location = await healthManager.getLocationDataForRoute(givenRoute: route)
                self.locations.append(contentsOf: location)
            }
        }
        
        do {
            let heartRates = try await healthManager.getHeartRateForActivity(activity: activity)
            self.heartRates = heartRates
        } catch { }
    }
    
}
