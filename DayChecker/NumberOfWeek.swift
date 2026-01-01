//
//  NumberOfWeek.swift
//  DayChecker
//
//  Created by 백상휘 on 1/1/26.
//

import Foundation

enum NumberOfWeek: Int, Hashable, Identifiable {
    var id: Int {
        rawValue
    }
    
    case prev, first, second, third, fourth, fifth, sixth
    var calendarValue: Int {
        switch self {
        case .prev: return -1
        case .first: return 0
        case .second: return 1
        case .third: return 2
        case .fourth: return 3
        case .fifth: return 4
        case .sixth: return 5
        }
    }
    
    init?(rawValue: Int) {
        switch rawValue {
        case -1: self = .prev
        case 0: self = .first
        case 1: self = .second
        case 2: self = .third
        case 3: self = .fourth
        case 4: self = .fifth
        case 5: self = .sixth
        default: return nil
        }
    }
}
