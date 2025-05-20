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

    @State private var searchText: String = ""

    // MARK: -
    var body: some View {
        NavigationStack {
            ListWithBluredHeader(maxBlurRadius: 32) {
                VStack(spacing: TKDesignSystem.Spacing.small) {
                    FilterMenu()
                        .fullWidth(.trailing)

                    Text(Word.activities)
                        .fullWidth(.leading)

                    SearchBarView("Recherche", searchText: $searchText) // TODO: TBL

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
                            .background(
                                NavigationLink("", destination: CyclingActivityDetailScreen(activity: activity))
                                    .opacity(0)
                            )
                    }
                    .noDefaultStyle()
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                    .padding(.bottom, TKDesignSystem.Padding.medium)

                    Rectangle()
                        .frame(height: 140)
                        .foregroundStyle(Color.clear)
                        .noDefaultStyle()
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
        }
    }
}

// MARK: - Preview
#Preview {
    ActivitiesScreen()
        .environmentObject(HealthManager())
        .environmentObject(NavigationManager(isPresented: .constant(nil)))
}
