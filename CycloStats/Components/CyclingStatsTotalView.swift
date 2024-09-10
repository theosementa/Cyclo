//
//  CyclingStatsTotalView.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

struct CyclingStatsTotalView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var healthManager: HealthManager

    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            Text(Word.Period.title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    CyclingStatsRow(
                        icon: "number",
                        title: Word.trips,
                        value: healthManager.numberOfCyclingWorkout.formatted(),
                        withBackground: true
                    )
                    
                    CyclingStatsRow(
                        icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                        title: Word.distance,
                        value: healthManager.totalDistance.formatWith(num: 2) + " km",
                        withBackground: true
                    )
                }
                
                HStack(spacing: 16) {
                    CyclingStatsRow(
                        icon: "mountain.2.fill",
                        title: Word.elevation,
                        value: healthManager.totalElevationAscended.formatWith(num: 2) + " m",
                        withBackground: true
                    )
                    CyclingStatsRow(
                        icon: "timer",
                        title: Word.duration,
                        value: healthManager.totalTime.asHoursMinutesAndSeconds,
                        withBackground: true
                    )
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingStatsTotalView()
        .padding()
        .environmentObject(HealthManager())
}
