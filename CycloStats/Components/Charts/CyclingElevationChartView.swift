//
//  CyclingElevationChartView.swift
//  CycloStats
//
//  Created by KaayZenn on 15/07/2024.
//

import SwiftUI
import Charts

struct CyclingElevationChartView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    
    // Computed
    var minYAxisValue: Double {
        healthManager.activitiesForCharts.map { $0.elevationInM }.min() ?? 0
    }
    
    var maxYAxisValue: Double {
        healthManager.activitiesForCharts.map { $0.elevationInM }.max() ?? 0
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "mountain.2.fill")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Text(Word.elevation)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Spacer()
            }
            
            Chart {
                ForEach(healthManager.activitiesForCharts, id: \.self) { activity in
                    LineMark(
                        x: .value("X", activity.date),
                        y: .value("Y", activity.elevationInM)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.green)
                    
                    RuleMark(y: .value("Average Elevation", healthManager.averageElevationPerDay))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .foregroundStyle(Color.white)
                        .annotation(position: .top, alignment: .leading) {
                            Text("\(Word.avg): \(healthManager.averageElevationPerDay.formatWith(num: 2)) m")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
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
        }
        .backgroundComponent()
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingElevationChartView()
}
