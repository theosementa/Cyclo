//
//  BottomBlurModifier.swift
//  SwiftUIArchitectureExample
//
//  Created by Theo Sementa on 08/05/2025.
//

import SwiftUI
import TheoKit

struct BottomBlurModifier: ViewModifier {

    // MARK: Dependencies
    var maxBlurRadius: CGFloat = 10
    var multiplier: CGFloat = 1

    // MARK: Environment
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    // MARK: - View
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                VStack {
                    Spacer()
                    VariableBlurView(maxBlurRadius: maxBlurRadius, direction: .blurredBottomClearTop)
                        .frame(height: safeAreaInsets.bottom * multiplier)
                }
                .ignoresSafeArea(edges: .bottom)
            }
    }
}

extension View {
    func bottomBlur(maxBlurRadius: CGFloat = 10, multiplier: CGFloat = 1) -> some View {
        return modifier(BottomBlurModifier(maxBlurRadius: maxBlurRadius, multiplier: multiplier))
    }
}
