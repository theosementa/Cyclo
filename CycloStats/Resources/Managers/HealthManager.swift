//
//  HealthManager.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation
import HealthKit

enum PeriodStatus {
    case start, end
}

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

final class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var selectedPeriod: Period = .month
    @Published private var cyclingActivities: [CyclingActivity] = []
    @Published var filteredCyclingActivities: [CyclingActivity] = []

    @Published var startDatePeriod: Date = Date().startOfMonth ?? .now
    @Published var endDatePeriod: Date = Date().endOfMonth ?? .now
}

extension HealthManager {
    
    func requestAutorisation() async -> Bool {
        let distanceCycling = HKQuantityType(.distanceCycling)
        let speedCycling = HKQuantityType(.cyclingSpeed)
        
        let workouts = HKObjectType.workoutType()
        let healthTypes: Set = [distanceCycling, speedCycling, workouts]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            return true
        } catch {
            return false
        }
    }

}

extension HealthManager {
    
    @MainActor
    func filterActivities() async {
        self.filteredCyclingActivities = cyclingActivities
            .filter { $0.date >= startDatePeriod && $0.date <= endDatePeriod }
    }
    
    var aggregatedActivities: [CyclingActivity] {
        var dailyDistances: [Date: Double] = [:]
        
        // Aggregate distances by date
        for activity in filteredCyclingActivities {
            let calendar = Calendar.current
            let date = calendar.startOfDay(for: activity.date)
            dailyDistances[date, default: 0] += activity.distanceInKm
        }
        
        // Convert dictionary to array
        return dailyDistances.map { date, distance in
            CyclingActivity(startDate: date, endDate: date, durationInMin: 0, distanceInKm: distance, averageSpeedInKMH: 0, elevationAscendedInM: 0)
        }.sorted(by: { $0.endDate < $1.endDate })
    }
    
    func changeDateWhenChangePeriod() {
        switch selectedPeriod {
        case .week:
            startDatePeriod = startDatePeriod.startOfWeek ?? .now
            endDatePeriod = startDatePeriod.endOfWeek ?? .now
        case .month:
            startDatePeriod = startDatePeriod.startOfMonth ?? .now
            endDatePeriod = startDatePeriod.endOfMonth ?? .now
        case .year:
            startDatePeriod = startDatePeriod.startOfYear ?? .now
            endDatePeriod = startDatePeriod.endOfYear ?? .now
        case .total:
            let startDate = filteredCyclingActivities.map { $0.endDate }.min() ?? .now
            let endDate = filteredCyclingActivities.map { $0.endDate }.max() ?? .now
            startDatePeriod = startDate
            endDatePeriod = endDate
        }
        
        Task { await filterActivities() }
    }
    
}

// MARK: - Cycling
extension HealthManager {
    var totalDistance: Double {
        return filteredCyclingActivities.map { $0.distanceInKm }.reduce(0, +)
    }
    
    var totalElevationAscended: Double {
        return filteredCyclingActivities.map { $0.elevationAscendedInM }.reduce(0, +)
    }
    
    var longestActivity: CyclingActivity? {
        return filteredCyclingActivities.sorted { $0.distanceInKm > $1.distanceInKm }.first
    }
    
    var highestActivity: CyclingActivity? {
        return filteredCyclingActivities.sorted { $0.elevationAscendedInM > $1.elevationAscendedInM }.first
    }
    
    var numberOfCyclingWorkout: Int {
        return filteredCyclingActivities.count
    }
    
    var averageDistancePerDay: Double {
        let totalDistance = aggregatedActivities.reduce(0) { $0 + $1.distanceInKm }
        return totalDistance / Double(aggregatedActivities.count)
    }
}

// MARK: - Cycling Stats Average
extension HealthManager {
    var averageDistanceInKm: Double {
        if !filteredCyclingActivities.isEmpty {
            return totalDistance / Double(filteredCyclingActivities.count)
        } else { return 0 }
    }
    
    var averageElevationInM: Double {
        if !filteredCyclingActivities.isEmpty {
            return totalElevationAscended / Double(filteredCyclingActivities.count)
        } else { return 0 }
    }
}

extension HealthManager {
    
    func fetchCyclingStats() {
        var firstDay: Date
        
        switch selectedPeriod {
        case .week: firstDay = .now.startOfWeek ?? .now
        case .month: firstDay = .now.startOfMonth ?? .now
        case .year: firstDay = .now.startOfYear ?? .now
        case .total: firstDay = .iPhoneReleaseDate ?? .now
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
                Task { await self.filterActivities() }
            }
        }
        
        healthStore.execute(query)
    }
        
}
