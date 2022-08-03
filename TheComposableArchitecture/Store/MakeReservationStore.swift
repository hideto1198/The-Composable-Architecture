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
    var menuSelector = Tab.personal
    var placeSelector = Tab.itagaki
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showTimeSchedule: Bool = false
    
    enum Tab {
        case none
        case personal
        case itagaki
        case ninomiya
    }

}

enum MakeReservationAction: Equatable {
    case onTapMenu(MakeReservationState.Tab)
    case onTapPlace(MakeReservationState.Tab)
    case onTapTrainer
    case onTapDate
    case onTapTime
}

struct MakeReservationEnvironment {
    
}

let makeReservationReducer: Reducer = Reducer<MakeReservationState, MakeReservationAction, MakeReservationEnvironment> { state, action, environemnt in
    switch action {
    case let .onTapMenu(tab):
        state.menuSelector = tab
        return .none
    case let .onTapPlace(tab):
        debugPrint("her: \(tab)")
        state.placeSelector = tab
        return .none
    case .onTapTrainer:
        return .none
    case .onTapDate:
        return .none
    case .onTapTime:
        return .none
    }
}
