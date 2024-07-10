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
                
                CyclingStatsView()
                    .padding()
                
                CyclingChartsView()
                    .padding()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Accueil")
        } // End NavigationStack
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeView()
}
