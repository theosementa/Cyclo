//
//  ActivityElevationChart.swift
//  CycloStats
//
//  Created by KaayZenn on 15/07/2024.
//

import SwiftUI
import Charts
import MapKit

struct ActivityElevationChart: View {
    
    // Builder
    var locations: [CLLocation]
    
    // Computed
    var minYAxisValue: Double {
        locations.map { $0.altitude }.min() ?? 0
    }
    
    var maxYAxisValue: Double {
        locations.map { $0.altitude }.max() ?? 0
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
                ForEach(locations, id: \.self) { location in
                    LineMark(
                        x: .value("X", location.timestamp),
                        y: .value("Y", location.altitude)
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
                Text("\(Word.min) : \(minYAxisValue.formatWith(num: 2))m")
                Text("\(Word.max) : \(maxYAxisValue.formatWith(num: 2))m")
                Spacer()
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
        .backgroundComponent()
    } // End body
} // End struct
