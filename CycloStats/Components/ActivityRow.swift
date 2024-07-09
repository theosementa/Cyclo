//
//  ActivityRow.swift
//  CycloStats
//
//  Created by KaayZenn on 09/07/2024.
//

import SwiftUI

struct ActivityRow: View {
    
    // Builder
    @ObservedObject var activity: CyclingActivity
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            Text("Dernière activité")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "timer")
                            Text("Durée")
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        
                        Text(activity.durationInMin.formatted() + " min")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath.fill")
                            Text("Distance")
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        
                        Text(activity.distanceInKm.formatWith(num: 2) + " km")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "figure.outdoor.cycle")
                            Text("Vitesse moyenne")
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        
                        Text(activity.averageSpeedInKMH.formatWith(num: 2) + " km/h")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "mountain.2.fill")
                            Text("Dénivelé")
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        
                        Text(activity.elevationAscendedInM.formatWith(num: 2) + " m")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .backgroundComponent()
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivityRow(activity: .preview)
        .padding()
}
