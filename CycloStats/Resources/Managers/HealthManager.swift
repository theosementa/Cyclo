//
//  HealthManager.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation
import HealthKit

enum Period {
    case week, month, year
}

final class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var selectedPeriod: Period = .month
    @Published var cyclingActivities: [CyclingActivity] = []
}

extension HealthManager {
    
    func requestAutorisation() {
        let distanceCycling = HKQuantityType(.distanceCycling)
        let speedCycling = HKQuantityType(.cyclingSpeed)
        
        let workouts = HKObjectType.workoutType()
        let healthTypes: Set = [distanceCycling, speedCycling, workouts]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch { }
        }
    }

}

// MARK: - Cycling
extension HealthManager {
    var totalDistance: Double {
        return cyclingActivities.map { $0.distanceInKm }.reduce(0, +)
    }
    
    var totalElevationAscended: Double {
        return cyclingActivities.map { $0.elevationAscendedInM }.reduce(0, +)
    }
    
    var longestActivity: CyclingActivity? {
        return cyclingActivities.sorted { $0.distanceInKm > $1.distanceInKm }.first
    }
    
    var highestActivity: CyclingActivity? {
        return cyclingActivities.sorted { $0.elevationAscendedInM > $1.elevationAscendedInM }.first
    }
    
    var numberOfCyclingWorkout: Int {
        return cyclingActivities.count
    }
}

extension HealthManager {
    
    func fetchCyclingStats() {
        var firstDay: Date
        
        switch selectedPeriod {
        case .week: firstDay = .firstDayOfWeek
        case .month: firstDay = .firstDayOfMonth
        case .year: firstDay = .firstDayOfYear
        }
        
        let workout = HKObjectType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: firstDay, end: .now)
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 1000, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else { return }
            
            var activities: [CyclingActivity] = []
 
            for workout in workouts {
//                print("/n")
            //                print("👋 STATS \(workout.allStatistics)")
            //                print("/n")
                var durationInMin: Int = 0
                var distanceInKm: Double = 0
                var elevationAscended: Double = 0
                
                durationInMin = Int(workout.duration) / 60
                
                if let distance = workout.statistics(for: .init(.distanceCycling))?.sumQuantity() {
                    distanceInKm = distance.doubleValue(for: .meter()) / 1000
                }
                
                if let workoutMetadata = workout.metadata {
                    if let workoutElevation = workoutMetadata[WorkoutMetadataKey.HKElevationAscended.rawValue] as? HKQuantity {
                        elevationAscended = workoutElevation.doubleValue(for: HKUnit.meter())
                    }
                }
                
                let totalDurationInHours = Double(durationInMin) / 60.0
                
                let activity = CyclingActivity(
                    startDate: workout.startDate,
                    endDate: workout.endDate,
                    durationInMin: Int(workout.duration / 60),
                    distanceInKm: distanceInKm,
                    averageSpeedInKMH: (distanceInKm / totalDurationInHours),
                    elevationAscendedInM: elevationAscended
                )
            
                activities.append(activity)
            }
            
            DispatchQueue.main.async {
                self.cyclingActivities = activities.sorted(by: { $0.endDate > $1.endDate })
            }
        }
        
        healthStore.execute(query)
    }
        
}
