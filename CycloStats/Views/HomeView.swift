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
            VStack(spacing: 2) {
                ScrollView {
                    CyclingChartsView()
                        .padding()
                    
                    CyclingStatsTotalView()
                        .padding()
                    
                    CyclingStatsAverageView()
                        .padding()
                }
                .scrollIndicators(.hidden)
                
                if healthManager.selectedPeriod != .total {
                    FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
            .background(Color.Apple.background.ignoresSafeArea())
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
