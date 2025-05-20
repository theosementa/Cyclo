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
    @Published var zones: [HeartRateZone] = []
    @Published var showFullMap: Bool = false
    @Published var showLegend: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: Error?
}

extension CyclingActivityDetailViewModel {
    func setupDetailView(activity: CyclingActivity, healthManager: HealthManager) async {
        await MainActor.run { isLoading = true }

        async let locationsTask: [CLLocation] = loadLocations(activity: activity, healthManager: healthManager)
        async let heartRateTask: (entries: [HeartRateEntry], zoneAnalysis: [HeartRateZone]) = loadHeartRates(activity: activity, healthManager: healthManager)

        do {
            let (locations, (heartRates, zones)) = try await (locationsTask, heartRateTask)

            await MainActor.run {
                self.locations = locations
                self.heartRates = heartRates
                self.zones = zones
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }

    private func loadLocations(activity: CyclingActivity, healthManager: HealthManager) async throws -> [CLLocation] {
        guard let workout = activity.originalWorkout,
              let routes = await healthManager.getWorkoutRoute(workout: workout) else {
            return []
        }

        // Process routes in parallel
        let locationArrays = await withTaskGroup(of: [CLLocation].self) { group in
            for route in routes {
                group.addTask {
                    await healthManager.getLocationDataForRoute(givenRoute: route)
                }
            }

            var results: [[CLLocation]] = []
            for await locations in group {
                results.append(locations)
            }
            return results
        }

        // Flatten the array of arrays
        return locationArrays.flatMap { $0 }
    }

    private func loadHeartRates(activity: CyclingActivity, healthManager: HealthManager) async throws -> (entries: [HeartRateEntry], zoneAnalysis: [HeartRateZone]) {
        do {
            return try await healthManager.getHeartRateForActivity(activity: activity)
        } catch {
            throw error
        }
    }
}
