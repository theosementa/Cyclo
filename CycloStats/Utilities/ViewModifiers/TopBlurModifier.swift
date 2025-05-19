//
//  TopBlurModifier.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit

struct TopBlurModifier: ViewModifier {

    // MARK: Dependencies
    var maxBlurRadius: CGFloat = 10
    var multiplier: CGFloat = 1

    // MARK: Environment
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    // MARK: - View
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                VariableBlurView(maxBlurRadius: maxBlurRadius)
                    .frame(height: safeAreaInsets.top * multiplier)
                    .ignoresSafeArea(edges: .top)
            }
    }
}

extension View {

    func topBlur(maxBlurRadius: CGFloat = 10, multiplier: CGFloat = 1) -> some View {
        return modifier(TopBlurModifier(maxBlurRadius: maxBlurRadius, multiplier: multiplier))
    }

}
