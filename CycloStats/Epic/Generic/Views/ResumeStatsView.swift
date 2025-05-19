//
//  ResumeStatsView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct ResumeStatsView: View {

    var distanceValue: Double
    var elevationValue: Double
    var timeValue: Double
    var outValue: Int?

    // MARK: - View
    var body: some View {
        HStack(spacing: TKDesignSystem.Spacing.large) {
            StatsRowView(title: "Distance", value: distanceValue.toString() + " km") // TODO: TBL
            StatsRowView(title: "Dénivelé", value: elevationValue.toString() + " m") // TODO: TBL
            StatsRowView(title: "Temps", value: timeValue.asHoursMinutes) // TODO: TBL
            if let outValue {
                StatsRowView(title: "Sorties", value: "\(outValue)") // TODO: TBL
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
    ResumeStatsView(
        distanceValue: 68.54,
        elevationValue: 532,
        timeValue: 123
    )
    .padding()
}
