//
//  HeartRateManager.swift
//  CycloStats
//
//  Created by Theo Sementa on 22/05/2025.
//

import Foundation
import HealthKit

final class HeartRateManager: ObservableObject {
    let healthStore = HKHealthStore()
}

extension HeartRateManager {

    func getHeartRateForActivity(activity: CyclingActivity) async throws -> HeartRateModel {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.sampleTypeNotAvailable
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: activity.startDate,
            end: activity.endDate,
            options: .strictEndDate
        )

        let entries: [HeartRateEntry] = try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(throwing: HealthKitError.unexpectedSampleType)
                    return
                }

                let unit = HKUnit(from: "count/min")
                let heartRateEntries = samples.map { sample in
                    HeartRateEntry(
                        heartRate: sample.quantity.doubleValue(for: unit),
                        date: sample.startDate
                    )
                }

                continuation.resume(returning: heartRateEntries)
            }

            self.healthStore.execute(query)
        }

        let zoneAnalysis = analyzeHeartRateZones(
            entries: entries,
            activityDuration: activity.endDate.timeIntervalSince(activity.startDate)
        )

        return HeartRateModel(entries: entries, zones: zoneAnalysis)
    }

}

// MARK: - Private Methods
extension HeartRateManager {

    private func analyzeHeartRateZones(entries: [HeartRateEntry], activityDuration: TimeInterval) -> [HeartRateZone] {
        var analyzedZones = HeartRateZone.all

        for index in 0..<entries.count - 1 {
            let currentEntry = entries[index]
            let nextEntry = entries[index + 1]
            let duration = nextEntry.date.timeIntervalSince(currentEntry.date)

            if let zoneIndex = analyzedZones.firstIndex(where: { $0.range.contains(currentEntry.heartRate) }) {
                analyzedZones[zoneIndex].timeSpent += duration
            }
        }

        // Calculate percentages
        for index in 0..<analyzedZones.count {
            analyzedZones[index].percentage = (analyzedZones[index].timeSpent / activityDuration) * 100
        }

        return analyzedZones
    }

}
