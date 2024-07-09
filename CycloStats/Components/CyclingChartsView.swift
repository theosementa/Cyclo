//
//  CyclingChartsView.swift
//  CycloStats
//
//  Created by KaayZenn on 09/07/2024.
//

import SwiftUI
import Charts

struct CyclingChartsView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    
    // MARK: -
    var body: some View {
        Chart {
            ForEach(healthManager.cyclingActivities) { activity in
                LineMark(
                    x: .value("X", activity.endDate),
                    y: .value("Y", activity.distanceInKm)
                )
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.green)
                
                AreaMark(
                    x: .value("X", activity.endDate),
                    y: .value("Y", activity.distanceInKm)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(LinearGradient(colors: [Color.green, Color.green.opacity(0)], startPoint: .top, endPoint: .bottom))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) {
//                let array = healthManager.cyclingActivities.sorted { $0.distanceInKm > $1.distanceInKm }
//                let value = array[$0.index].distanceInKm
                let value = $0.as(Int.self)!
                AxisValueLabel(horizontalSpacing: 8) {
                    Text(value.formatted())
                }
                AxisGridLine()
            }
        }
        .backgroundComponent()
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingChartsView()
}
