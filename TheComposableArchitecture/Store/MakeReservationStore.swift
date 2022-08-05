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
    var time_from: String
    var time_to: String
    var display_time: String
}

struct MakeReservationState: Equatable {
    var reservatopns: [MakeReservationEntity] = []
    var menuSelector: Int = 0
    var placeSelector: Int = 0
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showTimeSchedule: Bool = false
    var calendarState: CalendarState = CalendarState()
}

enum MakeReservationAction: Equatable {
    case calendarAction(CalendarAction)
    case onSelectMenu(Int)
    case onSelectPlace(Int)
    case onTapTrainer
    case onTapDate
    case onTapTime
}

struct MakeReservationEnvironment {
    
}

let makeReservationReducer: Reducer = Reducer<MakeReservationState, MakeReservationAction, MakeReservationEnvironment>.combine(
    calendarReducer.pullback(state: \MakeReservationState.calendarState,
                             action: /MakeReservationAction.calendarAction,
                             environment: { _ in CalendarEnvironment() }),
    Reducer { state, action, _ in
        switch action {
        case .calendarAction:
            return .none
        case let .onSelectMenu(index):
            state.menuSelector = index
            return .none
        case let .onSelectPlace(index):
            if index == 0 {
                state.showCalendar = false
            } else {
                state.showCalendar = true
            }
                state.placeSelector = index
            return .none
        case .onTapTrainer:
            return .none
        case .onTapDate:
            return .none
        case .onTapTime:
            return .none
        }
    }
)
