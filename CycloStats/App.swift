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
            HomeView()
                .environmentObject(healthManager)
                .onAppear {
                    healthManager.requestAutorisation()
                }
        }
    } // End body
} // End struct
