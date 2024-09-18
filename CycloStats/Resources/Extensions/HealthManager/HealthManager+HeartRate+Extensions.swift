//
//  HealthManager+HeartRate+Extensions.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import HealthKit
import SwiftUI

struct HeartRateEntry: Hashable, Identifiable {
    var heartRate: Double
    var date: Date
    var id = UUID()
}

struct HeartRateZone: Identifiable {
    let id: Int
    let range: ClosedRange<Double>
    var timeSpent: TimeInterval = 0
    var percentage: Double = 0
    var color: Color
    
    var stringRange: String {
        switch id {
        case 1: return "<138 BPM"
        case 2: return "138-151 BPM"
        case 3: return "152-165 BPM"
        case 4: return "166-179 BPM"
        default: return ">180 BPM"
        }
     }
    
    static var preview: HeartRateZone {
        return HeartRateZone(id: 2, range: 139...151, color: .green)
    }
}

extension HealthManager {
    
    func getHeartRateForActivity(activity: CyclingActivity) async throws -> (entries: [HeartRateEntry], zoneAnalysis: [HeartRateZone]) {
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
            
            let zoneAnalysis = analyzeHeartRateZones(entries: entries, activityDuration: activity.endDate.timeIntervalSince(activity.startDate))
            
            return (entries, zoneAnalysis)
        }
        
        private func analyzeHeartRateZones(entries: [HeartRateEntry], activityDuration: TimeInterval) -> [HeartRateZone] {
            var analyzedZones = zones
            
            for i in 0..<entries.count - 1 {
                let currentEntry = entries[i]
                let nextEntry = entries[i + 1]
                let duration = nextEntry.date.timeIntervalSince(currentEntry.date)
                
                if let zoneIndex = analyzedZones.firstIndex(where: { $0.range.contains(currentEntry.heartRate) }) {
                    analyzedZones[zoneIndex].timeSpent += duration
                }
            }
            
            // Calculate percentages
            for i in 0..<analyzedZones.count {
                analyzedZones[i].percentage = (analyzedZones[i].timeSpent / activityDuration) * 100
            }
            
            return analyzedZones
        }
    
}
