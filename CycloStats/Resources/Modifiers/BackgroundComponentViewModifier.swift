//
//  BackgroundComponentViewModifier.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation
import SwiftUI

struct BackgroundComponentViewModifier: ViewModifier {
    
    var radius: CGFloat?
    var isInSheet: Bool?
    var isPaddingEnabled: Bool?
    
    func body(content: Content) -> some View {
        content
            .padding((isPaddingEnabled ?? true) ? 16 : 0)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: radius ?? 16, style: .continuous)
                        .fill((isInSheet ?? false) ? Color.Apple.backgroundComponentSheet : Color.Apple.backgroundComponent)
                    
                    RoundedRectangle(cornerRadius: radius ?? 16, style: .continuous)
                        .stroke(lineWidth: 2)
                        .fill(Color.Apple.componentInComponent)
                }
            }
    }
}

extension View {
    
    func backgroundComponent(radius: CGFloat? = nil, isInSheet: Bool? = nil, isPaddingEnabled: Bool? = nil) -> some View {
        modifier(BackgroundComponentViewModifier(radius: radius, isInSheet: isInSheet, isPaddingEnabled: isPaddingEnabled))
    }
    
}
