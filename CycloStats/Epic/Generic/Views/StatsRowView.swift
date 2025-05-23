//
//  StatsRowView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct StatsRowView: View {

    // MARK: Dependencies
    var title: String
    var value: String
    var alignment: HorizontalAlignment = .leading

    // MARK: - View
    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(title)
                .fontWithLineHeight(Fonts.Body.small)
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            Text(value)
                .fontWithLineHeight(Fonts.Body.mediumBold)
                .foregroundStyle(Color.label)
        }
    }
}

// MARK: - Preview
#Preview {
    StatsRowView(title: "Distance", value: "68.54 km")
}
