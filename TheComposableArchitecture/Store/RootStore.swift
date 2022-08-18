//
//  RootStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import Foundation
import ComposableArchitecture

struct RootState {
    var reservation = ReservationState()
    var ticket = TicketState()
}

enum RootAction {
    case reservation(ReservationAction)
    case ticket(TicketAction)
    case onAppear
}

struct RootEnvironment {
    var reservationClient: ReservationClient
    var ticketClient: TicketClient
    var deleteClient: DeleteClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        reservationClient: ReservationClient.live,
        ticketClient: TicketClient.live,
        deleteClient: DeleteClient.live,
        mainQueue: .main
    )
}
let rootReducer: Reducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    .init { state, action, _ in
        switch action {
        case .onAppear:
            state = .init()
            return .none
        
        default:
            return .none
        }
    },
    reservationReducer
        .pullback(state: \.reservation,
                  action: /RootAction.reservation,
                  environment: { .init(reservationClient: $0.reservationClient, deleteClient: $0.deleteClient, mainQueue: $0.mainQueue)}),
    ticketReducer
        .pullback(state: \.ticket,
                  action: /RootAction.ticket,
                  environment: { .init(ticketClient: $0.ticketClient, mainQueue: $0.mainQueue)})
)
