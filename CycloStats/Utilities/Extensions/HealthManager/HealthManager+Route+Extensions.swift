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

        do {
            let samples = try await withCheckedThrowingContinuation {
                (continuation: CheckedContinuation<[HKSample], Error>) in
                let query = HKAnchoredObjectQuery(
                    type: HKSeriesType.workoutRoute(),
                    predicate: byWorkout,
                    anchor: nil,
                    limit: HKObjectQueryNoLimit,
                    resultsHandler: { (_, samples, _, _, error) in
                        if let hasError = error {
                            continuation.resume(throwing: hasError)
                            return
                        }

                        guard let samples = samples else {
                            return
                        }

                        continuation.resume(returning: samples)
                    }
                )

                healthStore.execute(query)
            }

            return samples as? [HKWorkoutRoute]
        } catch {
            return nil
        }
    }

    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                let allLocations = NSMutableArray()

                let query = HKWorkoutRouteQuery(route: givenRoute) { _, locationsOrNil, done, errorOrNil in

                    // Handle errors
                    if let error = errorOrNil {
                        continuation.resume(throwing: error)
                        return
                    }

                    // Process location batch
                    guard let currentLocationBatch = locationsOrNil else {
                        return
                    }

                    // Using thread-safe append method
                    allLocations.addObjects(from: currentLocationBatch)

                    // Resume continuation when complete
                    if done, let locations = allLocations as? [CLLocation] {
                        continuation.resume(returning: locations)
                    }
                }

                self.healthStore.execute(query)
            }
        } catch {
            // Consider logging the error here
            return []
        }
    }
}
