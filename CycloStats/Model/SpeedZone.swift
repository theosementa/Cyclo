//
//  SpeedZone.swift
//  CycloStats
//
//  Created by Theo Sementa on 18/09/2024.
//

import SwiftUI

struct SpeedZone: Identifiable {
    var id: Int
    var range: ClosedRange<Double>
    var color: Color
    
    var stringRange: String {
        switch id {
        case 1: return "<12 KM/H"
        case 2: return "12-18 KM/H"
        case 3: return "18-25 KM/H"
        case 4: return "25-35 KM/H"
        case 5: return "35-50 KM/H"
        default: return ">50 KM/H"
        }
     }
}

extension SpeedZone {
    
    static var zone1: SpeedZone {
        return SpeedZone(id: 1, range: 0...12, color: .customRed)
    }
    static var zone2: SpeedZone {
        return SpeedZone(id: 2, range: 12...18, color: .customOrange)
    }
    static var zone3: SpeedZone {
        return  SpeedZone(id: 3, range: 18...25, color: .customYellow)
    }
    static var zone4: SpeedZone {
        return SpeedZone(id: 4, range: 25...35, color: .customGreen)
    }
    static var zone5: SpeedZone {
        return SpeedZone(id: 5, range: 35...50, color: .customBlue)
    }
    static var zone6: SpeedZone {
        return SpeedZone(id: 6, range: 50...Double.infinity, color: .customPurple)
    }
    
}
