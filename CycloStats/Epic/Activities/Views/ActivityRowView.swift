//
//  ActivityRowView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct ActivityRowView: View {

    // MARK: Dependencies
    var activity: CyclingActivity

    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(activity.date.formatted(date: .complete, time: .omitted).capitalized)
                .fontWithLineHeight(.init(name: Fonts.fontMedium, size: 18, lineHeight: 24))
                .foregroundStyle(Color.label)

            HStack(spacing: TKDesignSystem.Spacing.large) {
                StatsRowView(title: "Distance", value: activity.distanceInKm.toString() + " km") // TODO: TBL
                StatsRowView(title: "Dénivelé", value: activity.elevationAscendedInM.toString() + " m") // TODO: TBL
                StatsRowView(title: "Temps", value: activity.durationInMin.asHoursMinutes) // TODO: TBL
            }
        }
        .fullWidth(.leading)
        .padding(TKDesignSystem.Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.small
        )
    }
}

// MARK: - Preview
#Preview {
    ActivityRowView(activity: .preview)
        .padding()
        .preferredColorScheme(.dark)
}
