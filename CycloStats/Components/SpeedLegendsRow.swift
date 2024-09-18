//
//  SpeedLegendsRow.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import SwiftUI

struct SpeedLegendsRow: View {
    
    // MARK: -
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading) {
            row(zone: .zone1)
            row(zone: .zone4)
            row(zone: .zone2)
            
            row(zone: .zone5)
            row(zone: .zone3)
            row(zone: .zone6)
        }
        .backgroundComponent()
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func row(zone: SpeedZone) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .frame(width: 16, height: 16)
            
            Text(zone.stringRange)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
        .foregroundColor(zone.color)
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SpeedLegendsRow()
}
