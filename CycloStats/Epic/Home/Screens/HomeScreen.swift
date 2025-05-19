//
//  HomeScreen.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI
import TheoKit

struct HomeScreen: View {

    // MARK: Environments
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: TKDesignSystem.Spacing.extraLarge) {
                VStack(spacing: TKDesignSystem.Spacing.medium) {
                    Text("Ce mois-ci") // TODO: TBL
                        .fontWithLineHeight(Fonts.Title.medium)
                        .fullWidth(.leading)

                    ResumeStatsView(
                        distanceValue: healthManager.currentMonthDistance,
                        elevationValue: healthManager.currentMonthElevationAscended,
                        timeValue: healthManager.currentMonthTime,
                        outValue: healthManager.numberOfCyclingWorkoutThisMonth
                    )

    //                VStack(spacing: 16) { // TODO: TODO
    //                    CyclingDistanceChartView()
    //                    CyclingElevationChartView()
    //                    CyclingHeartRateChartView()
    //                }
                }

                VStack(spacing: TKDesignSystem.Spacing.medium) {
                    Text("Dernières activités") // TODO: TBL
                        .fontWithLineHeight(Fonts.Title.medium)
                        .fullWidth(.leading)

                    ForEach(healthManager.cyclingActivities.prefix(5)) { activity in
                        NavigationLink(destination: CyclingActivityDetailScreen(activity: activity)) {
                            ActivityRowView(activity: activity)
                        }
                    }
                }

            }
            .padding(TKDesignSystem.Padding.large)
        }
        .scrollIndicators(.hidden)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeScreen()
}
