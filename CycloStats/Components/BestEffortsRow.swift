//
//  BestEffortsRow.swift
//  CycloStats
//
//  Created by Theo Sementa on 08/09/2024.
//

import SwiftUI

struct BestEffortsRow: View {
    
    // Builder
    var icon: String
    var title: String
    var activities: [CyclingActivity]
    var values: [Double]
    var unit: String
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Text(title)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(activities.indices, id: \.self) { index in
                    let activity = activities[index]
                    let value = values[index]
                    activityRow(index: index, value: value, activity: activity)
                }
            }
        }
        .backgroundComponent()
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func activityRow(index: Int, value: Double, activity: CyclingActivity) -> some View {
        var emoji: String {
            let medals = ["🥇", "🥈", "🥉"]
            return index < medals.count ? medals[index] : ""
        }
        
        HStack {
            Text("\(emoji) \(String(format: "%.2f", value))\(unit)")
            Spacer()
            Text(activity.date.formatted(date: .abbreviated, time: .omitted))
            Image(systemName: "chevron.right")
        }
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .foregroundStyle(Color.label)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.Apple.componentInComponent)
        }
        .onTapGesture { router.pushDetail(activity: activity) }
    }
    
} // End struct

// MARK: - Preview
#Preview {
    BestEffortsRow(
        icon: "person.fill",
        title: "Preview",
        activities: [.preview, .preview, .preview],
        values: [311, 145, 78],
        unit: "m"
    )
    .environmentObject(NavigationManager(isPresented: .constant(nil)))
    .padding()
}
