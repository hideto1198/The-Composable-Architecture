//
//  TrainerTimescheduleStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture

struct TrainerTimescheduleEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var time: String = ""
    var state: Int = 0
    var isTap: Bool = false
}

struct TrainerTimescheduleState: Equatable {
    @BindableState var timeFromSelector: Int = 0
    @BindableState var timeToSelector: Int = 0
    var times: Dictionary<String, TimescheduleEntity> = [:]
    var isLoading: Bool = false
    var timeFrom: String? = nil
    var reservationTime: String = "選択してください"
    var showTimeSchedule: Bool = false
    var showAddButton: Bool = false
    var showSetPlan: Bool = false
    var selectedTime: [String] = []
}

enum TrainerTimescheduleAction: Equatable, BindableAction {
    case binding(BindingAction<TrainerTimescheduleState>)
    case getTimeschedule
    case timescheduleResponse(Result<Dictionary<String, TimescheduleEntity>, TimescheduleClient.Failure>)
    case onTapTime(String)
    case onTapReservationTime
    case allSelect
    case allCancel
}

struct TrainerTimescheduleEnvironment {
    var timescheduleClient: TimescheduleClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        timescheduleClient: TimescheduleClient.live,
        mainQueue: .main
    )
}

let trainerTimescheduleReducer: Reducer = Reducer<TrainerTimescheduleState, TrainerTimescheduleAction, TrainerTimescheduleEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case let .onTapTime(time):
        state.timeFrom = time
        if state.times[state.timeFrom!]!.state != 1 {
            state.timeFrom = nil
            state.showAddButton = false
            return .none
        }
        state.times[state.timeFrom!]!.isTap = true
        state.showSetPlan = true
        state.selectedTime = [time]
        return .none
        
    case .onTapReservationTime:
        state.showTimeSchedule.toggle()
        return .none
        
    case .getTimeschedule:
        state.isLoading = true
        return environment.timescheduleClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerTimescheduleAction.timescheduleResponse)
        
    case let .timescheduleResponse(.success(response)):
        state.times = response
        state.isLoading = false
        return .none
        
    case .timescheduleResponse(.failure):
        state.isLoading = false
        return .none
    case .allSelect:
        for key in state.times.keys {
            if state.times[key]!.state == 1 {
                state.times[key]?.isTap = true
                state.selectedTime.append(key)
            }
        }
        state.showSetPlan = true
        return .none
    case .allCancel:
        for key in state.times.keys {
            state.times[key]?.isTap = false
        }
        state.selectedTime.removeAll()
        return .none
    }
}
.binding()
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
