//
//  ActivitiesView.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI

struct ActivitiesView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    @EnvironmentObject private var router: NavigationManager

    // MARK: -
    var body: some View {
        NavStack(router: router) {
            VStack(spacing: 2) {
                if healthManager.selectedPeriod != .total {
                    FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                        .padding(.horizontal)
                        .padding(.top, 4)
                }
                
                List(healthManager.filteredCyclingActivities) { activity in
                    ActivityRow(activity: activity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .padding(.top, 8)
            }
            .background(Color.Apple.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Activités")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FilterMenu()
                }
            }
        }
        .accentColor(.green)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivitiesView()
}
