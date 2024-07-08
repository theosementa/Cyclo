//
//  Color+Extensions.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation
import SwiftUI

extension Color {
    
    public init(hex: String) {
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17) & 0xFF, (int >> 4 * 17) & 0xFF, int * 17 & 0xFF)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            opacity: CGFloat(a) / 255
        )
    }
    
}

extension Color {
    
    public static var label: Color {
        return Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(Color.white) : UIColor(Color.black)
        })
    }
    
}

extension Color {
    
    public struct Apple {
        
        public static var background: Color {
            return Color(uiColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: "000000")) : UIColor(Color(hex: "F2F2F7"))
            })
        }
        
        public static var backgroundComponent: Color {
            return Color(uiColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: "1C1C1E")) : UIColor(Color(hex: "FFFFFF"))
            })
        }
        
        public static var backgroundComponentSheet: Color {
            return Color(uiColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: "2C2C2E")) : UIColor(Color(hex: "F2F2F7"))
            })
        }
        
        public static var backgroundSheet: Color {
            return Color(uiColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: "1C1C1E")) : UIColor(Color(hex: "FFFFFF"))
            })
        }
        
        public static var componentInComponent: Color {
            return Color(uiColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: "39393D")) : UIColor(Color(hex: "D9D9DE"))
            })
        }
    
    }
    
}
