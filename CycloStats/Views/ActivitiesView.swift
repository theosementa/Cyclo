//
//  ActivitiesView.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI

struct ActivitiesView: View {
    
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        NavigationStack {
            List(healthManager.filteredCyclingActivities) { activity in
                ActivityRow(activity: activity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Activités")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivitiesView()
}
