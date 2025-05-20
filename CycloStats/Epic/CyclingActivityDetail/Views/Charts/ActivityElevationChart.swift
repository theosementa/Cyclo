//
//  ActivityElevationChart.swift
//  CycloStats
//
//  Created by KaayZenn on 15/07/2024.
//

import SwiftUI
import Charts
import MapKit
import TheoKit

struct ActivityElevationChartView: View {

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
            HStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                Image(.iconMountain)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)

                Text(Word.elevation)
                    .fullWidth(.leading)
                    .fontWithLineHeight(Fonts.Title.medium)
            }
            .foregroundStyle(Color.label)

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
                Text("\(Word.min): \(minYAxisValue.formatWith(num: 2))m")
                    .fullWidth(.leading)
                Text("\(Word.max): \(maxYAxisValue.formatWith(num: 2))m")
                    .fullWidth(.leading)
            }
            .fontWithLineHeight(Fonts.Body.medium)
        }
        .padding(TKDesignSystem.Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.small
        )
    } // End body
} // End struct
