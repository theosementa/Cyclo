//
//  HealthManager+Route+Extensions.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import HealthKit
import CoreLocation

extension HealthManager {
    
    func getWorkoutRoute(workout: HKWorkout) async -> [HKWorkoutRoute]? {
        let byWorkout = HKQuery.predicateForObjects(from: workout)
        
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }
                
                guard let samples = samples else {
                    return
                }
                
                continuation.resume(returning: samples)
            }))
        }
        
        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }
        
        return workouts
    }
    
    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []
            
            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { (query, locationsOrNil, done, errorOrNil) in
                
                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let currentLocationBatch = locationsOrNil else {
                    return
                }
                
                allLocations.append(contentsOf: currentLocationBatch)
                
                if done {
                    continuation.resume(returning: allLocations)
                }
            }
            
            healthStore.execute(query)
        }
        
        return locations
    }
    
}
