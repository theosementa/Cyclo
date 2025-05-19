//
//  TappableButtonStyle.swift
//  CycloStats
//
//  Created by KaayZenn on 14/07/2024.
//

import SwiftUI

struct TappableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct TappableModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(TappableButtonStyle())
    }
}

extension View {
    func tappableStyle() -> some View {
        self.modifier(TappableModifier())
    }
}
