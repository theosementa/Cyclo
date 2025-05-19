//
//  Fonts.swift
//  POC_PhotoKit
//
//  Created by Theo Sementa on 14/05/2025.
//

import Foundation
import SwiftUICore

struct ExtendedUIFont {
    var name: String
    var size: CGFloat
    var lineHeight: CGFloat
}

struct Fonts {

    static var fontRegular: String = "Satoshi-Regular"
    static var fontMedium: String = "Satoshi-Medium"
    static var fontBold: String = "Satoshi-Bold"
    static var fontBlack: String = "Satoshi-Black"

    public struct Display {
        /// `This font is in "Bold 48" style`
        public static let huge: ExtendedUIFont = ExtendedUIFont(name: fontBlack, size: 48, lineHeight: 65)
        /// `This font is in "Bold 40" style`
        public static let extraLarge: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 40, lineHeight: 54)
        /// `This font is in "Bold 36" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 36, lineHeight: 48.6)
        /// `This font is in "Bold 32" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 32, lineHeight: 43.2)
        /// `This font is in "Bold 28" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 28, lineHeight: 37.8)

    }

    public struct Title {
        /// `This font is in "Bold 24" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 24, lineHeight: 32.4)
        /// `This font is in "Medium 20" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 20, lineHeight: 27)

    }

    public struct Body {
        /// `This font is in "Bold 18" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 18, lineHeight: 24.3)
        /// `This font is in "Bold 16" style`
        public static let mediumBold: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 16, lineHeight: 21.6)
        /// `This font is in "Medium 16" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 16, lineHeight: 21.6)
        /// `This font is in "Medium 14" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 14, lineHeight: 18.9)

    }

    public struct Label {
        /// `This font is in "Medium 12" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 12, lineHeight: 16.2)
        /// `This font is in "Bold 10" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 10, lineHeight: 13.5)
        /// `This font is in "Bold 8" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 8, lineHeight: 10.8)
    }
}
