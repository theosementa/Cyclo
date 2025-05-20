//
//  BestEffortChartView.swift
//  CycloStats
//
//  Created by Theo Sementa on 20/05/2025.
//

import SwiftUI
import TheoKit

struct BestEffortChartView: View {

    var icon: ImageResource
    var title: String
    var activities: [CyclingActivity]
    var values: [Double]
    var unit: String

    @State private var stepSize: CGFloat = 0

    // MARK: - View
    var body: some View {
        VStack(spacing: TKDesignSystem.Spacing.medium) {
            HStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)

                Text(title)
                    .fullWidth(.leading)
                    .fontWithLineHeight(Fonts.Title.medium)
            }
            .foregroundStyle(Color.label)

            HStack(alignment: .bottom, spacing: TKDesignSystem.Spacing.medium) {
                ForEach(activities.indices, id: \.self) { index in
                    let activity = activities[index]
                    let value = values[index]

                    let multiplier = (CGFloat(values.count - index) / CGFloat(values.count))
                    let brightness = -(1 - multiplier) * 0.3

                    NavigationLink(destination: CyclingActivityDetailScreen(activity: activity)) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .foregroundStyle(Color.appGreen.brightness(brightness))
                            .frame(height: stepSize * multiplier)
                            .getSize { size in
                                self.stepSize = size.width
                            }
                            .overlay {
                                Text(value.toString() + " \(unit)")
                                    .fontWithLineHeight(Fonts.Body.mediumBold)
                                    .foregroundStyle(Color.black)
                            }
                    }
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
    BestEffortChartView(
        icon: .iconMountain,
        title: "Dénivelé",
        activities: [.preview],
        values: [356.3, 234.1, 210.6],
        unit: "m"
    )
    .preferredColorScheme(.dark)
}
