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
                List {
                    if !healthManager.filteredCyclingActivities.isEmpty {
                        CyclingStatsTotalView()
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 24, leading: 16, bottom: 8, trailing: 16))
                        
                        VStack(spacing: 12) {
                            Text(Word.activities)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(healthManager.filteredCyclingActivities) { activity in
                                ActivityRow(activity: activity)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 32, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                
                if healthManager.selectedPeriod != .total {
                    FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
            .background(Color.Apple.background.ignoresSafeArea())
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(Word.activities)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FilterMenu()
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivitiesView()
        .environmentObject(HealthManager())
        .environmentObject(NavigationManager(isPresented: .constant(nil)))
}
