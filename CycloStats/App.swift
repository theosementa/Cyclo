//
//  CycloStatsApp.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

@main
struct CycloStatsApp: App {
    
    @StateObject private var healthManager: HealthManager = .init()
    
    private let homeRouter: NavigationManager = .init(isPresented: .constant(.home))
    private let activitiesRouter: NavigationManager = .init(isPresented: .constant(.activities))
    private let progressRouter: NavigationManager = .init(isPresented: .constant(.progress))

    // MARK: -
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .environmentObject(homeRouter)
                    .tabItem {
                        Label(Word.home, systemImage: "house.fill")
                    }
                
                ActivitiesView()
                    .environmentObject(activitiesRouter)
                    .tabItem {
                        Label(Word.activities, systemImage: "figure.outdoor.cycle")
                    }
                
                ActivitiesProgressView()
                    .environmentObject(progressRouter)
                    .tabItem {
                        Label(Word.progress, systemImage: "chart.bar.xaxis.ascending")
                    }
            } // End TabView
            .accentColor(.green)
            .environmentObject(healthManager)
            .task {
                if await healthManager.requestAutorisation() {
                    await healthManager.fetchCyclingStats()
                    await healthManager.filterActivities()
                }
            }
        }
    } // End body
} // End struct
