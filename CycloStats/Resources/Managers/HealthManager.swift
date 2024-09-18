//
//  HealthManager.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation
import HealthKit
import SwiftUI
import CoreLocation

enum HealthKitError: Error {
    case sampleTypeNotAvailable
    case unexpectedSampleType
}



final class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    let zones: [HeartRateZone] = [
        HeartRateZone(id: 1, range: 0...138, color: .blue),
        HeartRateZone(id: 2, range: 139...151, color: .green),
        HeartRateZone(id: 3, range: 152...165, color: .yellow),
        HeartRateZone(id: 4, range: 166...179, color: .orange),
        HeartRateZone(id: 5, range: 180...Double.infinity, color: .red)
    ]
    
    @Published var selectedPeriod: Period = .month
    @Published var cyclingActivities: [CyclingActivity] = []
    
    @Published var startDatePeriod: Date = Date().startOfMonth ?? .now
    @Published var endDatePeriod: Date = Date().endOfMonth ?? .now
    
    var queryAnchor: HKQueryAnchor?
    
    var filteredCyclingActivities: [CyclingActivity] {
        return self.cyclingActivities
            .filter { $0.date >= startDatePeriod && $0.date <= endDatePeriod }
    }
}

extension HealthManager {
    
    func requestAutorisation() async -> Bool {
        let distanceCycling = HKQuantityType(.distanceCycling)
        let speedCycling = HKQuantityType(.cyclingSpeed)
        let heartRate = HKQuantityType(.heartRate)
        
        let workouts = HKObjectType.workoutType()
        let summary = HKSeriesType.activitySummaryType()
        let routes = HKSeriesType.workoutRoute()
        let types = HKSeriesType.workoutType()
        
        let read: Set = [distanceCycling, speedCycling, heartRate, workouts, summary, routes, types]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: read)
            return true
        } catch { return false }
    }
    
}

extension HealthManager {
    
    func changeDateWhenChangePeriod() {
        switch selectedPeriod {
        case .week:
            startDatePeriod = .now
            startDatePeriod = startDatePeriod.startOfWeek ?? .now
            endDatePeriod = startDatePeriod.endOfWeek ?? .now
        case .month:
            startDatePeriod = .now
            startDatePeriod = startDatePeriod.startOfMonth ?? .now
            endDatePeriod = startDatePeriod.endOfMonth ?? .now
        case .year:
            startDatePeriod = startDatePeriod.startOfYear ?? .now
            endDatePeriod = startDatePeriod.endOfYear ?? .now
        case .total:
            let startDate = cyclingActivities.map { $0.endDate }.min() ?? .now
            let endDate = cyclingActivities.map { $0.endDate }.max() ?? .now
            startDatePeriod = startDate
            endDatePeriod = endDate
        }
    }
    
}

// MARK: - Charts
extension HealthManager {
    
    struct ChartData: Hashable {
        var date: Date
        var distanceInKm: Double
        var elevationInM: Double
        var averageHeartRate: Int
    }
    
    var activitiesForCharts: [ChartData] {
        var dailyData: [Date: (distance: Double, elevation: Double, heartRateSum: Int, activityCount: Int)] = [:]
        
        for activity in filteredCyclingActivities {
            let date = Calendar.current.startOfDay(for: activity.date)
            
            if dailyData[date] == nil {
                dailyData[date] = (distance: 0.0, elevation: 0.0, heartRateSum: 0, activityCount: 0)
            }
            
            dailyData[date]!.distance += activity.distanceInKm
            dailyData[date]!.elevation += activity.elevationAscendedInM
            dailyData[date]!.heartRateSum += activity.averageHeartRate
            dailyData[date]!.activityCount += 1
        }
        
        return dailyData.map { date, data in
            let averageHeartRate = data.activityCount > 0 ? data.heartRateSum / data.activityCount : 0
            
            return ChartData(
                date: date,
                distanceInKm: data.distance,
                elevationInM: data.elevation,
                averageHeartRate: averageHeartRate
            )
        }.sorted(by: { $0.date < $1.date })
    }
}

// MARK: - Cycling
extension HealthManager {
    var totalDistance: Double {
        return filteredCyclingActivities
            .map { $0.distanceInKm }.reduce(0, +)
    }
    
    var totalElevationAscended: Double {
        return filteredCyclingActivities
            .map { $0.elevationAscendedInM }.reduce(0, +)
    }
    
    var totalTime: Double {
        return filteredCyclingActivities
            .map { $0.durationInMin }.reduce(0, +)
    }
    
    var longestActivity: CyclingActivity? {
        return filteredCyclingActivities
            .sorted { $0.distanceInKm > $1.distanceInKm }.first
    }
    
    var highestActivity: CyclingActivity? {
        return filteredCyclingActivities
            .sorted { $0.elevationAscendedInM > $1.elevationAscendedInM }.first
    }
    
    var numberOfCyclingWorkout: Int {
        return filteredCyclingActivities.count
    }
}

extension HealthManager {
    
    @MainActor
    func fetchCyclingStats() async {
        let workout = HKObjectType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .iPhoneReleaseDate, end: .now)
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
                guard let workouts = sample as? [HKWorkout], error == nil else { return }
                continuation.resume(returning: workouts)
            }
            
            healthStore.execute(query)
        }
        
        guard let workouts = samples as? [HKWorkout] else { return }
        
        let activities = await mapWorkoutsToCyclingActivities(workouts: workouts)
        self.cyclingActivities = activities.sorted(by: { $0.endDate > $1.endDate })
    }
    
    private func mapWorkoutsToCyclingActivities(workouts: [HKWorkout]) async -> [CyclingActivity] {
        var activities = [CyclingActivity]()
        let cyclingActivityEntityRepo: CyclingActivityEntityRepo = .shared
        
        for workout in workouts {
            let durationInMin: Double = Double(workout.duration) / 60
            var distanceInKm: Double = 0
            var elevationAscended: Double = 0
            var averageHeartRate: Int = 0
            var maxHeartRate: Int = 0
            var maxSpeedInKMH: Double = 0
            
            let dateDifference = workout.endDate.timeIntervalSince(workout.startDate)
            let pauseTimeInMin = Double(dateDifference - workout.duration) / 60
            
            if let distance = workout.statistics(for: .init(.distanceCycling))?.sumQuantity() {
                distanceInKm = distance.doubleValue(for: .meter()) / 1000
            }
            
            if let workoutAverageHeartRate = workout.statistics(for: .init(.heartRate))?.averageQuantity() {
                averageHeartRate = Int(workoutAverageHeartRate.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
            }
            
            if let workoutHeartRateMax = workout.statistics(for: .init(.heartRate))?.maximumQuantity() {
                maxHeartRate = Int(workoutHeartRateMax.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
            }
            
            if let workoutMetadata = workout.metadata {
                if let workoutElevation = workoutMetadata[WorkoutMetadataKey.HKElevationAscended.rawValue] as? HKQuantity {
                    elevationAscended = workoutElevation.doubleValue(for: HKUnit.meter())
                }
            }
            
            let totalDurationInHours = Double(durationInMin) / 60.0
            
            // Get MaxSpeed
            if let activityEntity = cyclingActivityEntityRepo.activities.first(where: { $0.id == workout.uuid }) {
                maxSpeedInKMH = activityEntity.maxSpeed
            } else {
                if let routes = await self.getWorkoutRoute(workout: workout) {
                    for route in routes {
                        maxSpeedInKMH = await self.fetchMaxSpeed(givenRoute: route)
                        let newEntity = CyclingActivityEntity(context: viewContext)
                        newEntity.id = workout.uuid
                        newEntity.maxSpeed = maxSpeedInKMH
                        persistenceController.saveContext()
                    }
                }
            }
            
            let activity = CyclingActivity(
                id: workout.uuid,
                originalWorkout: workout,
                startDate: workout.startDate,
                endDate: workout.endDate,
                durationInMin: durationInMin,
                pauseTime: pauseTimeInMin,
                distanceInKm: distanceInKm,
                averageSpeedInKMH: (distanceInKm / totalDurationInHours),
                maxSpeedInKMH: maxSpeedInKMH,
                elevationAscendedInM: elevationAscended,
                averageHeartRate: averageHeartRate,
                maxHeartRate: maxHeartRate
            )
            
            activities.append(activity)
        }
        
        return activities
    }
    
}

extension HealthManager {
    
    func fetchMaxSpeed(givenRoute: HKWorkoutRoute) async -> Double {
        var maxSpeed: Double = 0
        
        let locations: [CLLocation] = await withCheckedContinuation { continuation in
            var allLocations: [CLLocation] = []
            let routeQuery = HKWorkoutRouteQuery(route: givenRoute) { (_, location, done, error) in
                if let error = error {
                    print("Erreur lors de la requête de points de route: \(error.localizedDescription)")
                    continuation.resume(returning: [])
                    return
                }
                
                if let location = location {
                    allLocations.append(contentsOf: location)
                }
                
                if done {
                    continuation.resume(returning: allLocations)
                }
            }
            healthStore.execute(routeQuery)
        }
        
        var previousLocation: CLLocation?
        
        for currentLocation in locations {
            if let previousLocation = previousLocation {
                let distance = currentLocation.distance(from: previousLocation)
                let time = currentLocation.timestamp.timeIntervalSince(previousLocation.timestamp)
                let speed = distance / time
                
                if speed > maxSpeed {
                    maxSpeed = speed
                }
            }
            previousLocation = currentLocation
        }
        
        let maxSpeedInKilometersPerHour = maxSpeed * 3.6
        return maxSpeedInKilometersPerHour
    }
    
}
