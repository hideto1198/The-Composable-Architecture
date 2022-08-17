//
//  HomeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import Foundation
import ComposableArchitecture

struct HomeState: Equatable {
    var reservationState: ReservationState = ReservationState()
    var ticketState: TicketState = TicketState()
    var isMenu: Bool = false
}

enum HomeAction: Equatable {
    case reservationAction(ReservationAction)
    case ticketAction(TicketAction)
    case onMenuTap
    case onAppear
    
}

struct HomeEnvironment {
    var reservationClient: ReservationClient
    var ticketClient: TicketClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        reservationClient: ReservationClient.live,
        ticketClient: TicketClient.live,
        mainQueue: .main
    )
}

let homeReducer: Reducer = Reducer<HomeState, HomeAction, HomeEnvironment>.combine(
    reservationReducer.pullback(state: \HomeState.reservationState,
                                action: /HomeAction.reservationAction,
                                environment: { .init(reservationClient: $0.reservationClient, mainQueue: $0.mainQueue)}),
    ticketReducer.pullback(state: \HomeState.ticketState,
                           action: /HomeAction.ticketAction,
                           environment: { .init(ticketClient: $0.ticketClient, mainQueue: $0.mainQueue)}),
    Reducer { state, action, environment in
        switch action {
        case .reservationAction, .ticketAction:
            return .none
        case .onMenuTap:
            state.isMenu = state.isMenu ? false : true
            return .none
        case .onAppear:
            if UserDefaults.standard.string(forKey: "first_launch") == nil {
                UserDefaults.standard.set(true, forKey: "first_launch")
            }
            return .none
        }
    }
)
