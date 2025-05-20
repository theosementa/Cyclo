//
//  ActivitiesProgressView.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI
import TheoKit

struct ActivitiesProgressScreen: View {

    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        ListWithBluredHeader(maxBlurRadius: 32) {
            VStack(spacing: TKDesignSystem.Spacing.small) {
                FilterMenu()
                    .fullWidth(.trailing)

                Text(Word.progress)
                    .fontWithLineHeight(Fonts.Title.large)
                    .fullWidth(.leading)

                if healthManager.selectedPeriod != .total {
                    FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                }
            }
            .padding(.horizontal, TKDesignSystem.Padding.large)
            .padding(.bottom, TKDesignSystem.Padding.large)
        } content: {
            ResumeStatsView(
                distanceValue: healthManager.totalDistance,
                elevationValue: healthManager.totalElevationAscended,
                timeValue: healthManager.totalTime,
                outValue: healthManager.numberOfCyclingWorkout
            )
            .noDefaultStyle()
            .padding(.horizontal, TKDesignSystem.Padding.large)
            .padding(.bottom, TKDesignSystem.Padding.large)

            ForEach(ActivityTarget.allCases, id: \.self) { target in
                CyclingTargetView(target: target)
                    .padding(.bottom, TKDesignSystem.Padding.medium)
            }
            .noDefaultStyle()
            .padding(.horizontal, TKDesignSystem.Padding.large)

            Rectangle()
                .frame(height: 140)
                .foregroundStyle(Color.clear)
                .noDefaultStyle()
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    }
}

// MARK: - Preview
#Preview {
    ActivitiesProgressScreen()
}
