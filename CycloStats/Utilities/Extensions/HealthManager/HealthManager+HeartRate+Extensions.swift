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

    static var all: [HeartRateZone] {
        return [
            HeartRateZone(id: 1, range: 0...138, color: .blue),
            HeartRateZone(id: 2, range: 139...151, color: .green),
            HeartRateZone(id: 3, range: 152...165, color: .yellow),
            HeartRateZone(id: 4, range: 166...179, color: .orange),
            HeartRateZone(id: 5, range: 180...Double.infinity, color: .red)
        ]
    }
}
