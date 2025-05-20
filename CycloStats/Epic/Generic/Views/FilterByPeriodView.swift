//
//  FilterByPeriodView.swift
//  MasteringChartsInSwiftUI
//
//  Created by Theo Sementa on 11/07/2024.
//

import SwiftUI
import TheoKit

struct FilterByPeriodView: View {

    // MARK: Dependencies
    var selectedPeriod: Period

    // MARK: Environment
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        HStack(spacing: 8) {
            CustomButtonView(animation: .smooth) { changePeriodDate(inPast: true) } label: {
                Image(.iconArrowLeft)
                    .renderingMode(.template)
                    .padding(TKDesignSystem.Padding.small)
                    .foregroundStyle(Color.label)
                    .roundedRectangleBorder(
                        TKDesignSystem.Colors.Background.Theme.bg100,
                        radius: TKDesignSystem.Radius.small
                    )
            }

            Group {
                switch selectedPeriod {
                case .week:
                    HStack(spacing: 8) {
                        Text(healthManager.startDatePeriod.formatted(date: .numeric, time: .omitted))
                        Text("word_to".localized)
                        Text(healthManager.endDatePeriod.formatted(date: .numeric, time: .omitted))
                    }
                case .month:
                    Text(healthManager.startDatePeriod.formatted(Date.FormatStyle().month(.wide).year()).capitalized)
                case .year:
                    Text(healthManager.startDatePeriod.formatted(Date.FormatStyle().year()))
                case .total:
                    EmptyView()
                }
            }
            .fontWithLineHeight(Fonts.Body.medium)
            .foregroundStyle(Color.label)
                .contentTransition(.numericText())
                .fullWidth()

            CustomButtonView(animation: .smooth) { changePeriodDate(inPast: false) } label: {
                Image(.iconArrowRight)
                    .renderingMode(.template)
                    .padding(TKDesignSystem.Padding.small)
                    .foregroundStyle(Color.label)
                    .roundedRectangleBorder(
                        TKDesignSystem.Colors.Background.Theme.bg100,
                        radius: TKDesignSystem.Radius.small
                    )
            }
        }
    }

    func changePeriodDate(inPast: Bool) {
        if inPast {
            healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInPast(selectedPeriod, .start)
            healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInPast(selectedPeriod, .end)
        } else {
            healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInFuture(selectedPeriod, .start)
            healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInFuture(selectedPeriod, .end)
        }
    }

}

// MARK: - Preview
#Preview {
    FilterByPeriodView(selectedPeriod: .month)
}
