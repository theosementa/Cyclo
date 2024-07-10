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

    // MARK: -
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Accueil", systemImage: "house.fill")
                    }
                
                ActivitiesView()
                    .tabItem {
                        Label("Activités", systemImage: "figure.outdoor.cycle")
                    }
                
                ActivitiesProgressView()
                    .tabItem {
                        Label("Progrès", systemImage: "chart.bar.xaxis.ascending")
                    }
            }
            
            .environmentObject(healthManager)
            .task {
                if await healthManager.requestAutorisation() {
                    healthManager.fetchCyclingStats()
                }
            }
            .onChange(of: healthManager.selectedPeriod) {
                healthManager.fetchCyclingStats()
            }
        }
    } // End body
} // End struct
