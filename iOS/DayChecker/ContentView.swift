//
//  ContentView.swift
//  DayChecker
//
//  Created by 백상휘 on 1/1/26.
//

import SwiftUI

struct IdentifiedDate: Identifiable {
    var id = UUID()
    let date: Date
}

struct ContentView: View {
    var headerDateFormat: DateFormatter
    var cellDateFormat: DateFormatter
    
    init() {
        let headerDateFormat = DateFormatter()
        headerDateFormat.dateFormat = "yyyy.MM.dd"
        self.headerDateFormat = headerDateFormat
        let cellDateFormat = DateFormatter()
        cellDateFormat.dateFormat = "d"
        self.cellDateFormat = cellDateFormat
    }
    
    var monthStart: Date? {
        Calendar.current.dateInterval(of: .month, for: Date())?.start
    }
    
    /// 현재 월의 날짜 범위를 가져옵니다
    var numberOfWeeksInCurrentMonth: [NumberOfWeek] {
        guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: Date()) else {
            return []
        }
        
        var result = range.compactMap {
            NumberOfWeek(rawValue: $0)
        }
        
        if let monthStart, Calendar.current.component(.day, from: monthStart) != 1 {
            result.insert(.prev, at: 0)
        }
        
        return range.compactMap {
            NumberOfWeek(rawValue: $0)
        }
    }
    /// 이번달 n번째주의 날짜를 모두 가져옴
    func getWeekDays(of numberOfWeek: NumberOfWeek) -> [IdentifiedDate] {
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 월의 시작일을 구합니다
        guard let monthStart else {
            return []
        }
        
        // TODO: 이전 달의 마지막 주 추가되는 경우 대응
        // 월 시작일부터 n주차에 해당하는 주의 시작일을 구합니다
        guard let weekStart = calendar.date(byAdding: .weekOfMonth,
                                            value: numberOfWeek.calendarValue,
                                            to: monthStart),
              let weekInterval = calendar.dateInterval(of: .weekOfMonth,
                                                       for: weekStart) else {
            return []
        }
        
        var result: [Date] = []
        var currentDate = weekInterval.start
        
        // 주의 모든 날짜를 배열에 추가합니다
        while currentDate < weekInterval.end {
            // 현재 월에 속한 날짜만 추가
            if calendar.component(.month, from: currentDate) == calendar.component(.month, from: now) {
                result.append(currentDate)
            }
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            
            currentDate = nextDate
        }
        
        return result.map { IdentifiedDate(date: $0) }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width: CGFloat = proxy.size.width / 7 - 12
            Grid {
                ForEach(numberOfWeeksInCurrentMonth) { numberOfRow in
                    GridRow {
                        ForEach(getWeekDays(of: numberOfRow)) { identifiedDate in
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                    .fill(Color.red)
                                    .frame(width: width , height: width)
                                Text(cellDateFormat.string(from: identifiedDate.date))
                            }
                        }
                    }
                }
            }
            .padding(17)
        }
    }
}

#Preview {
    ContentView()
}
