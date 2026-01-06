//
//  IdentifiedDate.swift
//  DayChecker
//
//  Created by 백상휘 on 1/6/26.
//


import SwiftUI

struct IdentifiedDate: Identifiable {
    var id = UUID()
    let date: Date
    var isHidden: Bool = false
}