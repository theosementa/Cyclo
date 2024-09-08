//
//  BestEffortsView.swift
//  CycloStats
//
//  Created by Theo Sementa on 08/09/2024.
//

import SwiftUI

struct BestEffortsView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    @EnvironmentObject private var router: NavigationManager
    
    // MARK: -
    var body: some View {
        NavStack(router: router) {
            List {
                Group {
                    let elevationBestEfforts: [CyclingActivity] = Array(healthManager.elevationBestEfforts.prefix(3))
                    let elevationBestEffortsValues = elevationBestEfforts.map(\.elevationAscendedInM)
                    BestEffortsRow(
                        icon: "mountain.2.fill",
                        title: Word.elevation,
                        activities: elevationBestEfforts,
                        values: elevationBestEffortsValues,
                        unit: "m"
                    )
                    .listRowInsets(.init(top: 32, leading: 16, bottom: 8, trailing: 16))

                    let distanceBestEfforts: [CyclingActivity] = Array(healthManager.distanceBestEfforts.prefix(3))
                    let distanceBestEffortsValues = distanceBestEfforts.map(\.distanceInKm)
                    BestEffortsRow(
                        icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                        title: Word.distance,
                        activities: distanceBestEfforts,
                        values: distanceBestEffortsValues,
                        unit: "km"
                    )
                    
                    let averageBestEfforts: [CyclingActivity] = Array(healthManager.averageSpeedBestEfforts.prefix(3))
                    let averageBestEffortsValues = averageBestEfforts.map(\.averageSpeedInKMH)
                    BestEffortsRow(
                        icon: "figure.outdoor.cycle",
                        title: Word.averageSpeed,
                        activities: averageBestEfforts,
                        values: averageBestEffortsValues,
                        unit: "km/h"
                    )
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
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
                    Text(Word.bestEfforts)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
            }
        }
    } // End body
} // Ens struct

// MARK: - Preview
#Preview {
    BestEffortsView()
}
