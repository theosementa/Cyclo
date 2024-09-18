//
//  ActivityHeartRateChart.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import SwiftUI
import Charts

struct ActivityHeartRateChart: View {
    
    // Builder
    var heartRates: [HeartRateEntry]
    var zones: [HeartRateZone]
    
    // Computed
    var minYAxisValue: Double {
        heartRates.map { $0.heartRate }.min() ?? 0
    }
    
    var maxYAxisValue: Double {
        heartRates.map { $0.heartRate }.max() ?? 0
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.heart")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Text("BPM")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Spacer()
            }
            
            Chart {
                ForEach(heartRates, id: \.self) { heartRate in
                    RectangleMark(
                        x: .value("X", heartRate.date),
                        y: .value("Y", heartRate.heartRate),
                        width: 3
                    )
                    .clipShape(Capsule())
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(colorByHeartRate(value: heartRate.heartRate))
                }
            }
            .frame(height: 200)
            .chartYScale(domain: (minYAxisValue - 5)...(maxYAxisValue + 5))
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) {
                    let value = $0.as(Int.self)!
                    AxisValueLabel(horizontalSpacing: 8) {
                        Text(value.formatted())
                    }
                    AxisGridLine()
                }
            }
            
            HStack(spacing: 24) {
                Text("\(Word.min): \(minYAxisValue.formatWith(num: 0)) BPM")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(Word.max): \(maxYAxisValue.formatWith(num: 0)) BPM")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            
            ForEach(zones) { zone in
                Divider()
                ZoneRow(zone: zone)
            }
        }
        .backgroundComponent()
    } // End body
    
    func colorByHeartRate(value: Double) -> Color {
        for zone in zones {
            if value > zone.range.lowerBound && value < zone.range.upperBound {
                return zone.color
            }
        }
        return .clear
    }
} // End struct
