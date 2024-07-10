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
                    Label(period.name, systemImage: period == healthManager.selectedPeriod ? "checkmark": "")
                }
            }
        } label: {
            HStack {
                Text(healthManager.selectedPeriod.name)
                Image(systemName: "chevron.up.chevron.down")
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    FilterMenu()
}
