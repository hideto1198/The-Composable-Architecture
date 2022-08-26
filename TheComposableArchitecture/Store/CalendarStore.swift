//
//  CalendarStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import Foundation
import ComposableArchitecture

struct DateEntity: Equatable, Hashable {
    var date: String = ""
    var state: String = ""
    var isToday: Bool = false
}

struct CalendarState: Equatable {
    var year: Int = 0
    var month: Int = 0
    var dates: [[DateEntity]] = [[]]
    
    // MARK: - 初期カレンダー作成
    mutating func makeCalendar() {
        let calendarModel: CalendarModel = CalendarModel()
        let today: Date = Date()
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        self.year = Int(dateFormatter.string(from: today).prefix(4))!
        self.month = Int(dateFormatter.string(from: today).suffix(2))!
        dates = calendarModel.calculationDate(year: self.year, month: self.month)
        banOldDay()
    }
    
    // MARK: - カレンダー更新
    mutating func UpdateCalendar() {
        let calendarModel: CalendarModel = CalendarModel()
        dates = calendarModel.calculationDate(year: self.year, month: self.month)
        banOldDay()
    }
    
    
    // MARK: - 選択できない日付を計算
    private mutating func banOldDay() {
        let today: Date = Date()
        var yesterday: Date? = Calendar.current.date(byAdding: .day, value: 0, to: today)
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        yesterday = dateFormatter.date(from: dateFormatter.string(from: yesterday!))
        for i in self.dates.indices {
            for n in self.dates[i].indices {
                guard self.dates[i][n].date != "" else { continue }
                let date: Date? = dateFormatter.date(from: "\(self.year)/\(self.month)/\(self.dates[i][n].date)")
                if date?.compare(yesterday!) == .orderedAscending {
                    self.dates[i][n].state = "×"
                } else {
                    self.dates[i][n].state = "○"
                }
            }
        }
    }
}

enum CalendarAction: Equatable {
    case onAppear
    case onTapNext
    case onTapPrevious
    case onTapTile(DateEntity)
}

struct CalendarEnvironment {
    
}

let calendarReducer:Reducer = Reducer<CalendarState, CalendarAction, CalendarEnvironment> { state, action, _ in
    switch action {
    case .onTapTile:
        return .none
    case .onAppear:
        state.makeCalendar()
        return .none
    case .onTapNext:
        if state.month == 12 {
            state.month = 1
        } else {
            state.month += 1
        }
        state.UpdateCalendar()
        return .none
    case .onTapPrevious:
        if state.month == 1 {
            state.month = 12
        } else {
            state.month -= 1
        }
        state.UpdateCalendar()
        return .none
    }
}
