//
//  ActivitiesScreen.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI
import TheoKit

struct ActivitiesScreen: View {

    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        NavigationStack {
            ListWithBluredHeader {
                VStack(spacing: 8) {
                    FilterMenu()
                        .fullWidth(.trailing)

                    if healthManager.selectedPeriod != .total {
                        FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                            .noDefaultStyle()
                    }
                }
                .padding(.horizontal, TKDesignSystem.Padding.large)
                .padding(.bottom, TKDesignSystem.Padding.large)
            } content: {
                if !healthManager.filteredCyclingActivities.isEmpty {
                    ForEach(healthManager.filteredCyclingActivities) { activity in
                        ActivityRowView(activity: activity)
                    }
                    .noDefaultStyle()
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                    .padding(.bottom, TKDesignSystem.Padding.medium)
                }
            }
            .background(TKDesignSystem.Colors.Background.Theme.bg50)
            .overlay {
                if healthManager.filteredCyclingActivities.isEmpty {
                    VStack {
                        Image(.mountainBiking)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 32)
                            .padding(.bottom)

                        Text(Word.nothingToSee)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text(Word.activities)
//                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    FilterMenu()
//                }
//            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivitiesScreen()
        .environmentObject(HealthManager())
        .environmentObject(NavigationManager(isPresented: .constant(nil)))
}
