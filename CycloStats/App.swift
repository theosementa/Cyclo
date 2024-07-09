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
                        Label("Home", systemImage: "house.fill")
                    }
                
                EmptyView()
                    .tabItem {
                        Label("Activités", systemImage: "figure.outdoor.cycle")
                    }
                
                EmptyView()
                    .tabItem {
                        Label("Progrè", systemImage: "chart.bar.xaxis.ascending")
                    }
            }
                .environmentObject(healthManager)
                .onAppear {
                    healthManager.requestAutorisation()
                }
        }
    } // End body
} // End struct
