//
//  TrainerCalendarStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import Foundation
import ComposableArchitecture

struct TrainerCalendarState: Equatable {
    var year: Int = 0
    var month: Int = 0
    var dates: [[DateEntity]] = [[]]
    var gymDates: [String] = []
    
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
        for i in dates.indices {
            for n in dates[i].indices {
                guard dates[i][n].date != "" else { continue }
                gymDates.append(dates[i][n].date)
            }
        }
    }
    
    // MARK: - カレンダー更新
    mutating func updateCalendar() {
        let calendarModel: CalendarModel = CalendarModel()
        dates = calendarModel.calculationDate(year: self.year, month: self.month)
        for i in dates.indices {
            for n in dates[i].indices {
                guard dates[i][n].date != "" else { continue }
                gymDates.append(dates[i][n].date)
            }
        }
        debugPrint(gymDates)
    }
}

enum TrainerCalendarAction: Equatable {
    static func == (lhs: TrainerCalendarAction, rhs: TrainerCalendarAction) -> Bool {
        return true
    }
    case onAppear
    case onTapNext(String)
    case onTapPrevious(String)
    case onTapTile
    case getGymDataResponse(Result<[String: Any], GetGymDataClient.Failure>)
    case getGymData(String)
}

struct TrainerCalendarEnvironment {
    var getGymDataClient: GetGymDataClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getGymDataClient: GetGymDataClient.live,
        mainQueue: .main
    )
}

let trainerCalendarReducer: Reducer = Reducer<TrainerCalendarState, TrainerCalendarAction, TrainerCalendarEnvironment> { state, action, environment in
    enum GetGymClientId {}
    switch action {
    case .onAppear:
        state.makeCalendar()
        return environment.getGymDataClient.fetch(state.year, state.month, state.dates, nil)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerCalendarAction.getGymDataResponse)
    case let .onTapNext(targetName):
        if state.month == 12 {
            state.month = 1
            state.year += 1
        } else {
            state.month += 1
        }
        state.updateCalendar()
        return environment.getGymDataClient.fetch(state.year, state.month, state.dates, targetName)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerCalendarAction.getGymDataResponse)
            .cancellable(id: GetGymClientId.self)
    case let .onTapPrevious(targetName):
        if state.month == 1 {
            state.month = 12
            state.year -= 1
        } else {
            state.month -= 1
        }
        state.updateCalendar()
        return environment.getGymDataClient.fetch(state.year, state.month, state.dates, targetName)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerCalendarAction.getGymDataResponse)
            .cancellable(id: GetGymClientId.self)
    case .onTapTile:
        return .none
    case let .getGymData(targetName):
        for i in state.dates.indices {
            for n in state.dates[i].indices {
                state.dates[i][n].state = state.dates[i][n].date != "" ? "99" : ""
            }
        }
        return environment.getGymDataClient.fetch(state.year, state.month, state.dates, targetName)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerCalendarAction.getGymDataResponse)
            .cancellable(id: GetGymClientId.self)
    case let .getGymDataResponse(.success(response)):
        if state.year == response["year"]! as! Int && state.month == response["month"] as! Int {
            state.dates = response["dates"]! as! [[DateEntity]]
        }
        return .none
    case .getGymDataResponse(.failure):
        return .none
    }
}
