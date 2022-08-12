//
//  CalendarStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import Foundation
import ComposableArchitecture

struct CalendarState: Equatable {
    var year: Int = 0
    var month: Int = 0
    var space: Int = 0
    var dates: [[DateEntity]] = [[]]
    
    struct DateEntity: Equatable, Hashable {
        var date: String = ""
        var state: String = ""
        var isTap: Bool = false
    }
    
    // MARK: - 初期カレンダー作成
    mutating func MakeCalendar() {
        let today: Date = Date()
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        self.year = Int(dateFormatter.string(from: today).prefix(4))!
        self.month = Int(dateFormatter.string(from: today).suffix(2))!
        dates = calculation_date(year: self.year, month: self.month)
        banOldDay()
    }
    
    // MARK: - カレンダー更新
    mutating func UpdateCalendar() {
        dates = calculation_date(year: self.year, month: self.month)
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
                let date: Date? = dateFormatter.date(from: "\(self.year)/\(self.month)/\(self.dates[i][n].date)")
                if date?.compare(yesterday!) == .orderedAscending {
                    self.dates[i][n].state = "×"
                }
            }
        }
    }
    
    // MARK: - 日付計算
    private func calculation_date(year: Int, month: Int) -> [[DateEntity]] {
        var dates: [[DateEntity]] = [[DateEntity]](repeating: [DateEntity](repeating: DateEntity(), count: 7), count: 6)
        var results: [[DateEntity]] = [[DateEntity]]()
        var space: Int = calculation_week(year: year, month: month, day: 1)
        var maxIndex: Int = 0
        let month31: [Int] = [1, 3, 5, 7, 8, 10, 12]
        var maxdate: Int = month31.firstIndex(of: month) != nil ? 31 : 30
        if month == 2 {
            maxdate = is366(year: year) ? 29 : 28
        }
        
        var date:Int = 1
        for i in dates.indices {
            for n in space ..< dates[i].count {
                if date != 0 {
                    if date > maxdate {
                        date = 0
                    }else{
                        dates[i][n].date = "\(date)"
                        dates[i][n].state = "○"
                        date += 1
                    }
                } else {
                    dates[i][n].state = ""
                }
            }
            space = 0
        }
        if dates[4].firstIndex(of: DateEntity(date: "\(maxdate)", state: "○")) != nil || dates[4].firstIndex(of: DateEntity(date: "\(maxdate)")) != nil {
            maxIndex = 5
        }else {
            maxIndex = 6
        }
        for i in 0 ..< maxIndex {
            results.append(dates[i])
        }
        return results
    }
    
    // MARK: - 曜日計算
    private func calculation_week(year: Int, month: Int, day: Int) -> Int {
        let C: Int = Int(floor(Double((month == 1 || month == 2 ? year - 1 : year) / 100)))
        let Y: Int = Int(floor(Double((month == 1 || month == 2 ? year - 1 : year) % 100)))
        let M: Int = Int(floor(Double(((month == 1 ? 13 : month == 2 ? 14 : month) + 1) * 26 / 10)))
        let I: Int = Int(floor(Double(Y / 4)))
        let H: Int = (day + M + Y + I - C * 2 + Int(floor(Double(C / 4))))
        let result: Int = H % 7
        switch result {
        case 0: return 6 // 土
        case 1: return 0 // 日
        case 2: return 1 // 月
        case 3: return 2 // 火
        case 4: return 3 // 水
        case 5: return 4 // 木
        case 6: return 5 // 金
        default: return 0
        }
    }
    
    // MARK: - うるう年チェック
    private func is366(year: Int) -> Bool {
        if year % 4 == 0 {
            if year % 100 == 0 {
                if year % 400 == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

enum CalendarAction: Equatable {
    case onAppear
    case onTapNext
    case onTapPrevious
    case onTapTile(CalendarState.DateEntity)
}

struct CalendarEnvironment {
    
}

let calendarReducer:Reducer = Reducer<CalendarState, CalendarAction, CalendarEnvironment> { state, action, _ in
    switch action {
    case .onTapTile:
        return .none
    case .onAppear:
        state.MakeCalendar()
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
