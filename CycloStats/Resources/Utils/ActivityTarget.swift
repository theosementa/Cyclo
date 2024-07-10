//
//  ActivityTarget.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import Foundation

enum ExplanationValue: String {
    case average = "Valeur moyenne"
    case reel = "Valeur réel"
}

enum ActivityTarget: CaseIterable {
    case montVentoux
    case metzToThionvile
    case metzToNancy
    case stageTourOfFrance
    case milanToRome
    case parisToMarseille
    case parisToDubai
    case circumferenceMoon
    case circumferenceEarth
    
    var title: String {
        switch self {
        case .montVentoux:          return "Mont ventoux"
        case .metzToThionvile:      return "Metz -> Thionville"
        case .metzToNancy:          return "Metz -> Nancy"
        case .stageTourOfFrance:    return "Étape du tour de France"
        case .milanToRome:          return "Milan -> Rome"
        case .parisToMarseille:     return "Paris -> Marseille"
        case .parisToDubai:         return "Paris -> Dubai"
        case .circumferenceMoon:    return "Tour de la Lune"
        case .circumferenceEarth:   return "Tour de la Terre"
        }
    }
    
    var value: Double {
        switch self {
        case .montVentoux:          return 20.8
        case .metzToThionvile:      return 29.2
        case .metzToNancy:          return 59.7
        case .stageTourOfFrance:    return 170
        case .milanToRome:          return 573.1
        case .parisToMarseille:     return 773.1
        case .parisToDubai:         return 6_802.4
        case .circumferenceMoon:    return 10_921
        case .circumferenceEarth:   return 40_075
        }
    }
    
    var explanationValue: String {
        switch self {
        case .montVentoux:          return ExplanationValue.reel.rawValue
        case .metzToThionvile:      return ExplanationValue.reel.rawValue
        case .metzToNancy:          return ExplanationValue.reel.rawValue
        case .stageTourOfFrance:    return ExplanationValue.average.rawValue
        case .milanToRome:          return ExplanationValue.reel.rawValue
        case .parisToMarseille:     return ExplanationValue.reel.rawValue
        case .parisToDubai:         return ExplanationValue.reel.rawValue
        case .circumferenceMoon:    return ExplanationValue.reel.rawValue
        case .circumferenceEarth:   return ExplanationValue.reel.rawValue
        }
    }
    
    var elevation: Double? {
        switch self {
        case .montVentoux:          return 1594
        case .metzToThionvile:      return 175
        case .metzToNancy:          return 350
        case .stageTourOfFrance:    return 1750
        case .milanToRome:          return 2650
        case .parisToMarseille:     return 3000
        case .parisToDubai:         return nil
        case .circumferenceMoon:    return nil
        case .circumferenceEarth:   return nil
        }
    }
    
    var explanationElevation: String? {
        switch self {
        case .montVentoux:          return ExplanationValue.reel.rawValue
        case .metzToThionvile:      return ExplanationValue.average.rawValue
        case .metzToNancy:          return ExplanationValue.average.rawValue
        case .stageTourOfFrance:    return ExplanationValue.average.rawValue
        case .milanToRome:          return ExplanationValue.average.rawValue
        case .parisToMarseille:     return ExplanationValue.average.rawValue
        case .parisToDubai:         return nil
        case .circumferenceMoon:    return nil
        case .circumferenceEarth:   return nil
        }
    }
    
}

extension ActivityTarget {
    
    func numberOfTime(distance: Double) -> (time: Int, progress: Double) {
        let time = distance / self.value
        let timeInt = Int(time)
        let progress = time - Double(timeInt)
        return (time: timeInt, progress: progress)
    }
    
}
