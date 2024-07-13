//
//  ActivitiesProgressView.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI

struct ActivitiesProgressView: View {
        
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        NavigationStack {
            VStack(spacing: 2) {
                if healthManager.selectedPeriod != .total {
                    FilterByPeriodView(selectedPeriod: healthManager.selectedPeriod)
                        .padding(.horizontal)
                        .padding(.top, 4)
                }
                
                List(ActivityTarget.allCases, id: \.self) { target in
                    CyclingTargetView(target: target)
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
                    Text("Progrès")
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
    ActivitiesProgressView()
}
