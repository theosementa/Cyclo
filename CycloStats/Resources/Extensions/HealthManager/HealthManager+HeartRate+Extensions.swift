//
//  HealthManager+HeartRate+Extensions.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import HealthKit

extension HealthManager {
    
    func getHeartRateForActivity(activity: CyclingActivity) async throws -> [HeartRateEntry] {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.sampleTypeNotAvailable
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: activity.startDate,
            end: activity.endDate,
            options: .strictEndDate
        )
        
        return try await withCheckedThrowingContinuation { continuation in
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
    }
    
}
