//
//  FilterMenu.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI

struct FilterMenu: View {
    
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        Menu {
            ForEach(Period.allCases, id: \.self) { period in
                Button { healthManager.selectedPeriod = period } label: {
                    if period == healthManager.selectedPeriod {
                        Label(period.name, systemImage: "checkmark")
                    } else {
                        Text(period.name)
                    }
                }
            }
        } label: {
            HStack {
                Text(healthManager.selectedPeriod.name)
                Image(systemName: "chevron.up.chevron.down")
            }
        }
        .onChange(of: healthManager.selectedPeriod) {
            healthManager.changeDateWhenChangePeriod()
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    FilterMenu()
}
