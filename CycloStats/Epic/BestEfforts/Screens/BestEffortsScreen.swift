//
//  BestEffortsScreen.swift
//  CycloStats
//
//  Created by Theo Sementa on 08/09/2024.
//

import SwiftUI
import TheoKit

struct BestEffortsScreen: View {

    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        NavigationStack {
            BetterScrollView(maxBlurRadius: 32) {
                Text(Word.bestEfforts)
                    .fontWithLineHeight(Fonts.Title.large)
                    .fullWidth(.leading)
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                    .padding(.bottom, TKDesignSystem.Padding.large)
            } content: { _ in
                VStack(spacing: TKDesignSystem.Spacing.medium) {
                    let elevationBestEfforts: [CyclingActivity] = Array(healthManager.elevationBestEfforts.prefix(3))
                    let elevationBestEffortsValues = elevationBestEfforts.map(\.elevationAscendedInM)
                    BestEffortChartView(
                        icon: .iconMountain,
                        title: Word.elevation,
                        activities: elevationBestEfforts,
                        values: elevationBestEffortsValues,
                        unit: "m"
                    )

                    let distanceBestEfforts: [CyclingActivity] = Array(healthManager.distanceBestEfforts.prefix(3))
                    let distanceBestEffortsValues = distanceBestEfforts.map(\.distanceInKm)
                    BestEffortChartView(
                        icon: .iconRoute,
                        title: Word.distance,
                        activities: distanceBestEfforts,
                        values: distanceBestEffortsValues,
                        unit: "km"
                    )

                    let maxSpeedBestEfforts: [CyclingActivity] = Array(healthManager.maxSpeedBestEfforts.prefix(3))
                    let maxSpeedBestEffortsValues = maxSpeedBestEfforts.map(\.maxSpeedInKMH)
                    BestEffortChartView(
                        icon: .iconGauge,
                        title: Word.maxSpeed,
                        activities: maxSpeedBestEfforts,
                        values: maxSpeedBestEffortsValues,
                        unit: "km/h"
                    )

                    let averageBestEfforts: [CyclingActivity] = Array(healthManager.averageSpeedBestEfforts.prefix(3))
                    let averageBestEffortsValues = averageBestEfforts.map(\.averageSpeedInKMH)
                    BestEffortChartView(
                        icon: .iconBike,
                        title: Word.averageSpeed,
                        activities: averageBestEfforts,
                        values: averageBestEffortsValues,
                        unit: "km/h"
                    )
                }
                .padding(.horizontal, TKDesignSystem.Padding.large)

                Rectangle()
                    .frame(height: 140)
                    .foregroundStyle(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(TKDesignSystem.Colors.Background.Theme.bg50)
            .navigationBarTitleDisplayMode(.inline)
        }
    } // End body
} // Ens struct

// MARK: - Preview
#Preview {
    BestEffortsScreen()
}
