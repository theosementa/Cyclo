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

    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .fontWithLineHeight(Fonts.Label.large)
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
