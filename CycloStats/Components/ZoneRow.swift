//
//  ZoneRow.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import SwiftUI

struct ZoneRow: View {
    
    // Builder
    var zone: HeartRateZone
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("\(Word.zone) \(zone.id) - \(zone.percentage.formatWith(num: 1))%")
                    .foregroundStyle(zone.color)
                
                Spacer()
                
                Text(zone.stringRange)
                    .foregroundStyle(Color(uiColor: .lightGray))
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            
            GeometryReader { geometry in
                HStack {
                    Capsule()
                        .foregroundStyle(zone.color)
                        .frame(width: geometry.size.width * (zone.percentage / 100), height: 10)
                    
                    Text("\((zone.timeSpent / 60).asHoursMinutesAndSeconds)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ZoneRow(zone: .preview)
}
