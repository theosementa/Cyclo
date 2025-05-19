//
//  TabbarView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct TabbarView: View {

    // MARK: Dependencies
    @Binding var selectedTab: CGFloat
    
    let icons: [ImageResource] = [.iconHouse, .iconBike, .iconStats, .iconTrophy]
    
    // MARK: - View
    var body: some View {
        HStack(spacing: TKDesignSystem.Spacing.small) {
            ForEach(icons.indices, id: \.self) { index in
                let icon = icons[index]
                let isSelected = selectedTab == CGFloat(index)
                Button {
                    selectedTab = CGFloat(index)
                } label: {
                    Image(icon)
                        .renderingMode(.template)
                        .foregroundStyle(isSelected ? Color.black : Color.label)
                        .padding(.vertical, TKDesignSystem.Padding.medium)
                        .fullWidth()
                }
            }
        }
        .padding(TKDesignSystem.Padding.extraSmall)
        .fullWidth()
        .background {
            GeometryReader { geo in
                let outerPadding = TKDesignSystem.Padding.extraSmall
                let spacing = TKDesignSystem.Spacing.small
                let width = geo.size.width
                
                let tabWidth = (width - (2 * outerPadding) - (spacing * CGFloat(icons.count - 1))) / CGFloat(icons.count)
                let xPosition = outerPadding + (selectedTab * (tabWidth + spacing))
                
                RoundedRectangle(cornerRadius: TKDesignSystem.Radius.small, style: .continuous)
                    .fill(Color.appGreen)
                    .frame(width: tabWidth)
                    .offset(x: xPosition)
            }
            .padding(.vertical, 4)
        }
        .animation(.smooth, value: selectedTab)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.medium
        )
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var selectedTab: CGFloat = 1
    TabbarView(selectedTab: $selectedTab)
        .preferredColorScheme(.dark)
}
