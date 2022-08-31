import Foundation

class CalendarModel {
    // MARK: - 日付計算
    func calculationDate(year: Int, month: Int) -> [[DateEntity]] {
        var dates: [[DateEntity]] = [[DateEntity]](repeating: [DateEntity](repeating: DateEntity(), count: 7), count: 6)
        var results: [[DateEntity]] = [[DateEntity]]()
        var space: Int = calculationWeek(year: year, month: month, day: 1)
        var maxIndex: Int = 0
        let month31: [Int] = [1, 3, 5, 7, 8, 10, 12]
        var maxDate: Int = month31.firstIndex(of: month) != nil ? 31 : 30
        if month == 2 {
            maxDate = is366(year: year) ? 29 : 28
        }
        
        var date:Int = 1
        for i in dates.indices {
            for n in space ..< dates[i].count {
                if date != 0 {
                    if date > maxDate {
                        date = 0
                    }else{
                        dates[i][n].date = "\(date)"
                        if checkToday(year: year, month: month, date: date) {
                            dates[i][n].isToday = true
                        }
                        dates[i][n].state = "99"
                        date += 1
                    }
                } else {
                    dates[i][n].state = ""
                }
            }
            space = 0
        }
        if dates[4].firstIndex(of: DateEntity(date: "\(maxDate)", state: "99", isToday: true)) != nil || dates[4].firstIndex(of: DateEntity(date: "\(maxDate)", state: "99", isToday: false)) != nil {
            maxIndex = 5
        } else {
            maxIndex = 6
        }
        
        for i in 0 ..< maxIndex {
            results.append(dates[i])
        }
        return results
    }
    // MARK: - 今日かどうか判別する
    private func checkToday(year: Int, month: Int, date: Int) -> Bool {
        let today: Date = Date()
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        
        if dateFormatter.string(from: today) == dateFormatter.string(from: dateFormatter.date(from: "\(String(year))/\(month)/\(date)")!) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 曜日計算
    private func calculationWeek(year: Int, month: Int, day: Int) -> Int {
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

/*
let calendarModel: CalendarModel = CalendarModel()
let dates: [[DateEntity]] = calendarModel.calculationDate(year: 2022, month: 8)
for i in dates.indices {
    for n in dates[i].indices {
        print(dates[i][n])
    }
}
*/
