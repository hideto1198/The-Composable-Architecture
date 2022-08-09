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
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showTimeSchedule: Bool = false
    var calendarState: CalendarState = CalendarState()
    var trainerState: TrainerState = TrainerState()
}

enum MakeReservationAction: Equatable {
    case calendarAction(CalendarAction)
    case trainerAction(TrainerAction)
    case onSelectMenu(Int)
    case onSelectPlace(Int)
    case onTapTrainer
    case onTapDate
    case onTapTime
}

struct MakeReservationEnvironment {
    var trainerClient: TrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        trainerClient: TrainerClient.live,
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
    Reducer { state, action, _ in
        switch action {
        case let .calendarAction(.onTapTile(date)):
            if date.state == "○" {
                state.showTrainer = true
            }
            return .none
        case .calendarAction:
            return .none
        case .trainerAction:
            return .none
        case let .onSelectMenu(index):
            state.menuSelector = index
            return .none
        case let .onSelectPlace(index):
            if index == 0 {
                state.showCalendar = false
                state.showTrainer = false
                state.trainer = "選択してください"
            } else {
                state.showCalendar = true
            }
                state.placeSelector = index
            return .none
        case .onTapTrainer:
            state.trainer = "テスト　トレーナー"
            return .none
        case .onTapDate:
            return .none
        case .onTapTime:
            return .none
        }
    }
)
