//
//  CalendarViewModel.swift
//  DayChecker
//
//  Created by 백상휘 on 1/6/26.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var date: Date
    
    private(set) var headerDateFormat: DateFormatter
    private(set) var cellDateFormat: DateFormatter
    
    var monthStart: Date? {
        Calendar.current.dateInterval(of: .month, for: date)?.start
    }
    
    init(date: Date = Date()) {
        self.date = date
        
        let headerDateFormat = DateFormatter()
        headerDateFormat.dateFormat = "MMM yyyy"
        self.headerDateFormat = headerDateFormat
        let cellDateFormat = DateFormatter()
        cellDateFormat.dateFormat = "d"
        self.cellDateFormat = cellDateFormat
    }
    
    func setDate(_ date: Date) {
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        
        let newDate = Calendar.current.date(from: DateComponents(year: year, month: month))
        self.date = newDate ?? date
        self.objectWillChange.send()
    }
    
    /// 현재 월의 날짜 범위를 가져옵니다
    func getNumberOfWeeksInCurrentMonth() -> [NumberOfWeek] {
        guard let monthStart,
              let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: date)
        else {
            return []
        }
        
        var result: [NumberOfWeek] = []
        
        // 월의 첫날이 일요일(1)이 아니면 이전 달의 마지막 주를 추가
        let weekday = Calendar.current.component(.weekday, from: monthStart)
        if weekday != 1 {  // 1 = 일요일
            result.append(.prev)
            // 현재 월의 주차들 추가
            result.append(contentsOf: range.compactMap {
                NumberOfWeek(rawValue: $0)
            })
        } else {
            // 현재 월의 주차들 추가
            result.append(contentsOf: (0..<range.count).compactMap {
                NumberOfWeek(rawValue: $0)
            })
        }
        
        return result
    }
    /// 이번달 n번째주의 날짜를 모두 가져옴
    func getWeekDays(of numberOfWeek: NumberOfWeek) -> [IdentifiedDate] {
        let calendar = Calendar.current
        
        // 현재 월의 시작일을 구합니다
        guard let monthStart else {
            return []
        }
        
        // .prev인 경우 월 시작일이 속한 주를 가져오고, 그 외에는 기존 로직 사용
        let weekInterval: DateInterval
        if numberOfWeek == .prev {
            // 월 시작일이 속한 주의 구간을 가져옴
            guard let interval = calendar.dateInterval(of: .weekOfMonth, for: monthStart) else {
                return []
            }
            weekInterval = interval
        } else {
            // 월 시작일부터 n주차에 해당하는 주의 시작일을 구합니다
            guard let weekStart = calendar.date(byAdding: .weekOfMonth,
                                                value: numberOfWeek.calendarValue,
                                                to: monthStart),
                  let interval = calendar.dateInterval(of: .weekOfMonth, for: weekStart) else {
                return []
            }
            weekInterval = interval
        }
        
        var result: [Date] = []
        var currentDate = weekInterval.start
        
        let currentMonth = calendar.component(.month, from: date)
        
        // 주의 모든 날짜를 배열에 추가합니다
        while currentDate < weekInterval.end {
            let dateMonth = calendar.component(.month, from: currentDate)
            
            // 이전 달 마지막 주(.prev)인 경우 이전 달과 현재 달 날짜 모두 포함
            // 그 외의 경우 현재 월에 속한 날짜만 추가
            if numberOfWeek == .prev {
                // 이전 달이거나 현재 달인 날짜 추가
                if dateMonth == currentMonth || dateMonth == (currentMonth == 1 ? 12 : currentMonth - 1) {
                    result.append(currentDate)
                }
            } else {
                // 현재 월에 속한 날짜만 추가
                if dateMonth == currentMonth {
                    result.append(currentDate)
                }
            }
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            
            currentDate = nextDate
        }
        
        return result.map {
            let hidden = Calendar.current.compare($0, to: monthStart, toGranularity: .month) != .orderedSame
            return IdentifiedDate(date: $0, isHidden: hidden)
        }
    }
    
    private func setNewMonth(_ newValue: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: newValue, to: date) else {
            return
        }
        self.setDate(newDate)
//        self.date = newDate
    }
    
    func goPrevMonth() {
        setNewMonth(-1)
    }
    
    func goNextMonth() {
        setNewMonth(1)
    }
}
