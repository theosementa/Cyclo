//
//  CyclingStatsView.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

struct CyclingStatsView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "number")
                        Text("Sorties")
                    }
                    .font(.system(size: 14, weight: .medium, design: .rounded))

                    Text(healthManager.numberOfCyclingWorkout.formatted())
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .backgroundComponent()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath.fill")
                        Text("Distance")
                    }
                    .font(.system(size: 14, weight: .medium, design: .rounded))

                    Text(healthManager.totalDistance.formatWith(num: 2) + " km")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .backgroundComponent()
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "mountain.2.fill")
                    Text("Dénivelé")
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))

                Text(healthManager.totalElevationAscended.formatWith(num: 2) + " m")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .backgroundComponent()
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingStatsView()
        .padding()
        .environmentObject(HealthManager())
}
