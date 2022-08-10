//
//  MakeReservationStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import Foundation
import ComposableArchitecture


struct MakeReservationEntity: Equatable {
    var menu_name: String
    var place_name: String
    var year: String
    var month: String
    var day: String
    var trainer_name: String = ""
    var time_from: String
    var time_to: String
    var display_time: String
}

struct MakeReservationState: Equatable {
    var reservatopns: [MakeReservationEntity] = []
    var menuSelector: Int = 0
    var placeSelector: Int = 0
    var trainerSelector: Int = 0
    var trainer: String = "選択してください"
    var showTrainerSelector: Bool = false
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showReservationDate: Bool = false
    var reservation_date: String = "選択してください"
    var showTimeSchedule: Bool = false
    var reservationTime: String = "選択してください"
    var showReservationTime: Bool = false
    var showAddButton: Bool = false
    var calendarState: CalendarState = CalendarState()
    var trainerState: TrainerState = TrainerState()
    var timescheduleState: TimescheduleState = TimescheduleState()
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var time_from: String = ""
    var time_to: String = ""
    var displayTime: String = ""
    
    fileprivate mutating func resetState(){
        self.trainer = "選択してください"
        self.showTrainerSelector = false
        self.showTrainer = false
        self.showCalendar = false
        self.showReservationDate = false
        self.reservation_date = "選択してください"
        self.showTimeSchedule = false
        self.showReservationTime = false
        self.reservationTime = "選択してください"
        self.showAddButton = false
        
    }
}

enum MakeReservationAction: Equatable {
    case calendarAction(CalendarAction)
    case trainerAction(TrainerAction)
    case timescheduleAction(TimescheduleAction)
    case onSelectMenu(Int)
    case onSelectPlace(Int)
    case onTapTrainer
    case onTapDate
    case onTapTime
    case onTapAddButton
}

struct MakeReservationEnvironment {
    var trainerClient: TrainerClient
    var timescheduleClient: TimescheduleClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        trainerClient: TrainerClient.live,
        timescheduleClient: TimescheduleClient.live,
        mainQueue: .main
    )
}

let makeReservationReducer: Reducer = Reducer<MakeReservationState, MakeReservationAction, MakeReservationEnvironment>.combine(
    calendarReducer.pullback(state: \MakeReservationState.calendarState,
                             action: /MakeReservationAction.calendarAction,
                             environment: { _ in CalendarEnvironment() }),
    trainerReducer.pullback(state: \MakeReservationState.trainerState,
                            action: /MakeReservationAction.trainerAction,
                            environment: { .init(trainerClient: $0.trainerClient, mainQueue: $0.mainQueue) }),
    timescheduleReducer.pullback(state: \MakeReservationState.timescheduleState,
                                 action: /MakeReservationAction.timescheduleAction,
                                 environment: { .init(timescheduleClient: $0.timescheduleClient, mainQueue: $0.mainQueue) }),
    Reducer { state, action, _ in
        switch action {
        // MARK: - カレンダーの日付を押したときの処理
        case let .calendarAction(.onTapTile(date)):
            state.showTrainer = false
            if date.state == "○" {
                state.showTrainerSelector = true
                state.showCalendar = false
                state.showReservationDate = true
                state.showTrainer = true
                state.reservation_date = "\(state.calendarState.year)年\(state.calendarState.month)月\(date.date)日"
                state.year = "\(state.calendarState.year)"
                state.month = "\(state.calendarState.month)"
                state.day = date.date
                return Effect(value: .trainerAction(.getTrainer))
            } else {
                state.year = ""
                state.month = ""
                state.day = ""
                state.showTrainer = false
                return .none
            }
            
        case .calendarAction:
            return .none
        // MARK: - トレーナーを選択したときの処理
        case let .trainerAction(.onTapTrainer(trainer)):
            state.showTimeSchedule = false
            state.trainer = trainer.trainer_name
            state.showTrainer = false
            state.showReservationTime = true
            state.reservationTime = "選択してください"
            state.showTimeSchedule = true
            state.timescheduleState.times.removeAll()
            return Effect(value: .timescheduleAction(.getTimeschedule))
            
        case .trainerAction:
            return .none
        
        // MARK: - 時間を選択したときの処理
        case let .timescheduleAction(.onTapTime(time)):
            guard time != "22:30" else { return .none }
            let next_time: String = next_time_value(time: time)
            let display_time: String = next_time_value(time: next_time)
            if state.timescheduleState.times[time]!.state == 1 && state.timescheduleState.times[next_time]!.state == 1 {
                state.reservationTime = "\(time)〜\(display_time)"
                state.time_from = time
                state.time_to = next_time
                state.displayTime = display_time
                state.showTimeSchedule = false
                state.showAddButton = true
            } else {
                state.time_from = ""
                state.time_to = ""
                state.displayTime = ""
                state.showAddButton = false
            }
            return .none
            
        case .timescheduleAction:
            return .none
            
        case let .onSelectMenu(index):
            state.menuSelector = index
            return .none
        
        // MARK: - 場所を選択したときの処理
        case let .onSelectPlace(index):
            if index == 0 {
                state.resetState()
            } else {
                state.resetState()
                state.showCalendar = true
                state.showReservationDate = true
            }
            state.placeSelector = index
            return .none
            
        case .onTapTrainer:
            state.showTrainer.toggle()
            return .none
            
        case .onTapDate:
            state.resetState()
            state.showCalendar = true
            state.showReservationDate = true
            return .none
            
        // MARK: - 追加ボタンを押したときの処理
        case .onTapTime:
            state.showTimeSchedule.toggle()
            return .none
        case .onTapAddButton:
            debugPrint("trainer:\(state.trainer)¥nyear: \(state.year)¥nmonth: \(state.month)¥nday: \(state.day)¥ntime_from: \(state.time_from)¥ntime_to: \(state.time_to)¥ndisplayTime: \(state.displayTime)")
            return .none
        }
    }
)

fileprivate func next_time_value(time: String) -> String {
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
