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
                    LineMark(
                        x: .value("X", heartRate.date),
                        y: .value("Y", heartRate.heartRate)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.green)
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
                Text("\(Word.min) : \(minYAxisValue.formatWith(num: 0))bpm")
                Text("\(Word.max) : \(maxYAxisValue.formatWith(num: 0))bpm")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
        .backgroundComponent()
    } // End body
} // End struct
