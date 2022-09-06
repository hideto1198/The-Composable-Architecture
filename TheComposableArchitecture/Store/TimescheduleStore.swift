//
//  TimescheduleStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import Foundation
import ComposableArchitecture

struct TimescheduleEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var time: String = ""
    var state: Int = 0
    var isTap: Bool = false
}

struct TimescheduleState: Equatable {
    var times: Dictionary<String, TimescheduleEntity> = [:]
    var isLoading: Bool = false
    var timeFrom: String? = nil
    var timeTo: String? = nil
    var displayTime: String? = nil
    var reservationTime: String {
        guard let timeFrom = self.timeFrom else { return "選択してください" }
        guard let displayTime = self.displayTime else { return "選択してください" }
        return "\(timeFrom)〜\(displayTime)"
    }
    var showTimeSchedule: Bool = false
    var showAddButton: Bool = false
}

enum TimescheduleAction: Equatable {
    case getTimeschedule
    case timescheduleResponse(Result<Dictionary<String, TimescheduleEntity>, TimescheduleClient.Failure>)
    case onTapTime(String)
    case onTapReservationTime
}

struct TimescheduleEnvironment {
    var timescheduleClient: TimescheduleClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        timescheduleClient: TimescheduleClient.live,
        mainQueue: .main
    )
}

let timescheduleReducer: Reducer = Reducer<TimescheduleState, TimescheduleAction, TimescheduleEnvironment> { state, action, environment in
    switch action {
    case let .onTapTime(time):
        guard time != "22:30" else { return .none }
        state.timeFrom = time
        state.timeTo = nextTimeValue(time: state.timeFrom!)
        state.displayTime = nextTimeValue(time: state.timeTo!)
        if state.times[state.timeFrom!]!.state != 1 || state.times[state.timeTo!]!.state != 1 {
            state.timeFrom = nil
            state.timeTo = nil
            state.displayTime = nil
            state.showAddButton = false
            return .none
        }
        state.showTimeSchedule = false
        state.showAddButton = true
        return .none
        
    case .onTapReservationTime:
        state.showTimeSchedule.toggle()
        return .none
        
    case .getTimeschedule:
        state.isLoading = true
        return environment.timescheduleClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TimescheduleAction.timescheduleResponse)
        
    case let .timescheduleResponse(.success(response)):
        state.times = response
        state.isLoading = false
        return .none
        
    case .timescheduleResponse(.failure):
        state.isLoading = false
        return .none
    }
}

fileprivate func nextTimeValue(time: String) -> String {
    let times: [String] = [
        "9:00","9:30","10:00","10:30","11:00","11:30",
        "12:00","12:30","13:00","13:30","14:00","14:30",
        "15:00","15:30","16:00","16:30","17:00","17:30",
        "18:00","18:30","19:00","19:30","20:00","20:30",
        "21:00","21:30","22:00","22:30","23:00"
    ]
    let result: Int = times.firstIndex(of: time)! + 1
    return times[result]
}
