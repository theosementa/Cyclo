//
//  DistanceAndSpeedActivityDetailView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct DistanceAndSpeedActivityDetailView: View {

    // MARK: Dependencies
    var activity: CyclingActivity

    // MARK: - View
    var body: some View {
        VStack(spacing: TKDesignSystem.Spacing.standard) {
            Text("Distance & Vitesse") // TODO: TBL
                .fontWithLineHeight(Fonts.Title.medium)
                .fullWidth(.leading)

            VStack(spacing: TKDesignSystem.Spacing.medium) {
                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.distance, value: activity.distanceInKm.toString() + " km")
                        .fullWidth(.leading)

                    StatsRowView(title: Word.elevation, value: activity.elevationAscendedInM.toString() + " m")
                        .fullWidth(.leading)
                }

                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.averageSpeed, value: activity.averageSpeedInKMH.toString() + " km/h")
                        .fullWidth(.leading)

                    StatsRowView(title: Word.maxSpeed, value: activity.maxSpeedInKMH.toString() + " km/h")
                        .fullWidth(.leading)
                }
            }
        }
        .padding(TKDesignSystem.Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.small
        )
    }
}

// MARK: - Preview
#Preview {
    DistanceAndSpeedActivityDetailView(activity: .preview)
}
