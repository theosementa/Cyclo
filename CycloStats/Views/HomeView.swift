//
//  HomeView.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                SelectPeriodButtons(period: $healthManager.selectedPeriod)
                
                CyclingChartsView()
                    .padding()
                
                CyclingStatsTotalView()
                    .padding()
                
                CyclingStatsAverageView()
                    .padding()
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Accueil")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FilterMenu()
                }
            }
        } // End NavigationStack
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeView()
}
