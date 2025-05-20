//
//  BackButtonView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct BackButtonView: View {

    @Environment(\.dismiss) private var dismiss

    // MARK: - View
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                Image(.iconArrowLeft)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)

                Text("Retour") // TODO: TBL
                    .fontWithLineHeight(Fonts.Body.medium)
            }
            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
        }

    }
}

// MARK: - Preview
#Preview {
    BackButtonView()
}
