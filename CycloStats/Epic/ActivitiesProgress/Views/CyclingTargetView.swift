//
//  CyclingTargetView.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI
import TheoKit

struct CyclingTargetView: View {

    // MARK: Dependencies
    var target: ActivityTarget

    // MARK: Environments
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        let numberOfTime = target.numberOfTime(distance: healthManager.totalDistance)

        VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.medium) {
            VStack(alignment: .leading, spacing: 0) {
                Text(target.title)
                    .fontWithLineHeight(.init(name: Fonts.fontMedium, size: 18, lineHeight: 24))
                Text("\(Word.traveled) \(numberOfTime.time) fois") // TODO: TBL
                    .fontWithLineHeight(Fonts.Body.small)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }

            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .frame(height: 24)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg200)
                    .overlay(alignment: .leading) {
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appGreen)
                                .frame(width: geo.size.width * numberOfTime.progress)
                                .overlay(alignment: .leading) {
                                    if numberOfTime.progress >= 0.20 {
                                        Text((numberOfTime.progress * 100).toString(maxDigits: 1) + "%")
                                            .fontWithLineHeight(Fonts.Body.small)
                                            .foregroundStyle(Color.black)
                                            .padding(.leading)
                                    }
                                }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .overlay(alignment: .trailing) {
                        if numberOfTime.progress < 0.20 {
                            Text((numberOfTime.progress * 100).toString(maxDigits: 1) + "%")
                                .fontWithLineHeight(Fonts.Body.small)
                                .foregroundStyle(Color.appGreen)
                                .padding(.trailing)
                        }
                    }

                let progressAlreadyDoInKm = numberOfTime.progress * target.value
                let progressRemainingInKm = target.value - (numberOfTime.progress * target.value)
                HStack {
                    Text("\(Word.traveled) \(progressAlreadyDoInKm.toString()) km")
                        .fullWidth(.leading)
                    Text("\(Word.remaining) \(progressRemainingInKm.toString()) km")
                        .fullWidth(.trailing)
                }
                .fontWithLineHeight(Fonts.Body.small)
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
    CyclingTargetView(target: .montVentoux)
        .padding()
        .environmentObject(HealthManager())
        .preferredColorScheme(.dark)
}
