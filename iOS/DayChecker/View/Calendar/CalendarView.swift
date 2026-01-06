//
//  CalendarView.swift
//  DayChecker
//
//  Created by 백상휘 on 1/6/26.
//

import SwiftUI

struct CalendarView: View {
    let viewModel = CalendarViewModel()
    
    var body: some View {
        CalendarHeader(viewModel: viewModel)
        CalendarBody(viewModel: viewModel)
    }
}

#Preview {
    CalendarView()
}
