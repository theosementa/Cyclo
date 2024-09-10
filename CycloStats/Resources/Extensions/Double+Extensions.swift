//
//  Double+Extensions.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

extension Double {
    
    public func formatWith(num: Int) -> String {
        return String(format: "%.\(num)f", self)
    }
    
    var asHoursMinutesAndSeconds: String {
        let totalSeconds = Int(self * 60)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%dh %02dmin %02ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dmin %02ds", minutes, seconds)
        } else {
            return "\(seconds)s"
        }
    }
    
}
