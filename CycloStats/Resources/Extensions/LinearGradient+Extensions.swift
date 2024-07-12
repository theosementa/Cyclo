//
//  LinearGradient+Extensions.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import Foundation
import SwiftUI

extension LinearGradient {
    
    static var backgroudButton: LinearGradient {
        return LinearGradient(
            stops: [
                Gradient.Stop(
                    color: Color(uiColor: .systemBackground).opacity(0),
                    location: 0.00
                ),
                Gradient.Stop(
                    color: Color(uiColor: .systemBackground),
                    location: 1.00
                )
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 0.27)
        )
    }
}
