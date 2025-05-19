//
//  HeartActivityDetailView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct HeartActivityDetailView: View {

    // MARK: Dependencies
    var activity: CyclingActivity

    // MARK: - View
    var body: some View {
        VStack(spacing: TKDesignSystem.Spacing.standard) {
            Text("Coeur") // TODO: TBL
                .fontWithLineHeight(Fonts.Title.medium)
                .fullWidth(.leading)

            VStack(spacing: TKDesignSystem.Spacing.medium) {
                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.averageBPM, value: "\(activity.averageHeartRate) bpm")
                        .fullWidth(.leading)

                    StatsRowView(title: Word.maxBPM, value: "\(activity.maxHeartRate) bpm")
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
    HeartActivityDetailView(activity: .preview)
}
