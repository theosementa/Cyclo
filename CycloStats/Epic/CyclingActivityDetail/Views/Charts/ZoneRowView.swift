//
//  ZoneRowView.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import SwiftUI
import TheoKit

struct ZoneRowView: View {

    // Builder
    var zone: HeartRateZone

    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("\(Word.zone) \(zone.id) - \(zone.percentage.formatWith(num: 1))%")
                    .fontWithLineHeight(Fonts.Body.medium)
                    .foregroundStyle(zone.color)

                Spacer()

                Text(zone.stringRange)
                    .fontWithLineHeight(Fonts.Body.medium)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))

            GeometryReader { geometry in
                HStack {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .foregroundStyle(zone.color)
                        .frame(width: geometry.size.width * (zone.percentage / 100), height: 10)

                    Text("\((zone.timeSpent / 60).asHoursMinutesAndSeconds)")
                        .fontWithLineHeight(Fonts.Body.small)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ZoneRowView(zone: .preview)
}
