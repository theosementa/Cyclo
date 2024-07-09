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
        ScrollView {
            SelectPeriodButtons(period: $healthManager.selectedPeriod)
            
            if let lastActivity = healthManager.cyclingActivities.first {
                ActivityRow(activity: lastActivity)
                    .padding()
            }
 
            CyclingStatsView()
                .padding()
//            
//            CyclingChartsView()
//                .padding()
            
            VStack(spacing: 12) {
                Text("Progrès")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 12) {
                    CyclingTargetView(target: .montVentoux)
                    CyclingTargetView(target: .metzToThionvile)
                    CyclingTargetView(target: .metzToNancy)
                    CyclingTargetView(target: .stageTourOfFrance)
                    CyclingTargetView(target: .milanToRome)
                    CyclingTargetView(target: .parisToMarseille)
                    CyclingTargetView(target: .parisToDubai)
                    CyclingTargetView(target: .circumferenceMoon)
                    CyclingTargetView(target: .circumferenceEarth)
                }
            }
            .padding()
        
        }
        .scrollIndicators(.hidden)
        .onAppear {
            healthManager.fetchCyclingStats()
        }
        .onChange(of: healthManager.selectedPeriod) {
            healthManager.fetchCyclingStats()
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeView()
}
