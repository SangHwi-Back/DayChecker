//
//  CalendarBody.swift
//  DayChecker
//
//  Created by 백상휘 on 1/6/26.
//

import SwiftUI

struct CalendarBody: View {
    let viewModel: CalendarViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let width: CGFloat = proxy.size.width / 7 - 7
            Grid {
                ForEach(viewModel.getNumberOfWeeksInCurrentMonth()) { numberOfRow in
                    GridRow {
                        ForEach(viewModel.getWeekDays(of: numberOfRow)) { identifiedDate in
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                    .fill(identifiedDate.isHidden ? Color.clear : Color.red)
                                    .frame(width: width , height: width)
                                if identifiedDate.isHidden == false {
                                    Text(viewModel.cellDateFormat.string(
                                        from: identifiedDate.date))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarBody(viewModel: .init())
}
