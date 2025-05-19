//
//  CycloStatsApp.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI
import TheoKit

@main
struct CycloStatsApp: App {

    @StateObject private var healthManager: HealthManager = .init()
    @StateObject private var cyclingActivityEntityRepo: CyclingActivityEntityRepo = .shared
    @StateObject private var appManager: AppManager = .shared

    // MARK: - View
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                switch appManager.selectedTab {
                case 0:
                    HomeScreen()
                case 1:
                    ActivitiesScreen()
                case 2:
                    ActivitiesProgressScreen()
                case 3:
                    BestEffortsScreen()
                default:
                    EmptyView()
                }

                TabbarView(selectedTab: $appManager.selectedTab)
                    .padding(TKDesignSystem.Padding.large)
            }
            .environmentObject(healthManager)
            .task {
                if await healthManager.requestAutorisation() {
                    await cyclingActivityEntityRepo.fetchActivities()
                    await healthManager.fetchCyclingStats()
                }
            }
        }
    }
}
