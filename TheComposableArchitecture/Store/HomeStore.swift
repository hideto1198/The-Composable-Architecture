//
//  HomeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import Foundation
import ComposableArchitecture

struct HomeState: Equatable {
    @BindableState var isMakeTrainer: Bool = false
    @BindableState var isTrainer: Bool = false
    var reservationState: ReservationState = ReservationState()
    var ticketState: TicketState = TicketState()
    var isMenu: Bool = false
    var isLoading: Bool = false
    var offset: Double = -(bounds.width)
    var opacity: Double = 0.0
    var alert: AlertState<HomeAction>?
}

enum HomeAction: Equatable, BindableAction {
    case reservationAction(ReservationAction)
    case ticketAction(TicketAction)
    case onTapMenu
    case onAppear
    case deleteResponse(Result<Bool, DeleteClient.Failure>)
    case getTicket
    case ticketResponse(Result<TicketEntity, TicketClient.Failure>)
    case alertDismissed
    case onTapOk(ReservationEntity)
    case binding(BindingAction<HomeState>)
    case onTapLogo
}

struct HomeEnvironment {
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

let homeReducer: Reducer = Reducer<HomeState, HomeAction, HomeEnvironment>.combine(
    reservationReducer.pullback(state: \HomeState.reservationState,
                                action: /HomeAction.reservationAction,
                                environment: { .init(reservationClient: $0.reservationClient, deleteClient: $0.deleteClient, mainQueue: $0.mainQueue)}),
    ticketReducer.pullback(state: \HomeState.ticketState,
                           action: /HomeAction.ticketAction,
                           environment: { .init(ticketClient: $0.ticketClient, mainQueue: $0.mainQueue)}),
    Reducer { state, action, environment in
        switch action {
        case .binding:
            return .none
        case let .reservationAction(.onTapDelete(reservation)):
            state.alert = AlertState(title: TextState("確認"),
                                     message: TextState("予約をキャンセルしてよろしいでしょうか"),
                                     primaryButton: .cancel(TextState("いいえ")),
                                     secondaryButton: .destructive(TextState("はい"),
                                                               action: .send(HomeAction.onTapOk(reservation))))
            return .none
        case .ticketAction(.getTicket):
            return .none
        case .reservationAction, .ticketAction:
            return .none
        case .onTapMenu:
            state.isMenu = state.isMenu ? false : true
            if state.isMenu {
                state.opacity = 1.0
                state.offset = bounds.width * -0.3
            } else {
                state.opacity = 0.0
                state.offset = -(bounds.width)
            }
            return .none
        case .onAppear:
            if UserDefaults.standard.string(forKey: "first_launch") == nil {
                UserDefaults.standard.set(true, forKey: "first_launch")
            }
            return .none
        case let .deleteResponse(.success(response)):
            state.isLoading = false
            if response {
                return Effect(value: HomeAction.getTicket)
            } else {
                return .none
            }
        case .deleteResponse(.failure):
            state.isLoading = false
            return .none
        case .getTicket:
            return environment.ticketClient.fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(HomeAction.ticketResponse)
        case let .ticketResponse(.success(response)):
            state.ticketState.ticket = response
            return Effect(value: HomeAction.reservationAction(.getReservation))
        case .ticketResponse(.failure):
            return .none
        case let .onTapOk(reservation):
            state.alert = nil
            state.isLoading = true
            for i in state.reservationState.reservations.indices {
                state.reservationState.reservations[i].isTap = false
            }
            return environment.deleteClient.fetch(reservation)
                .receive(on: environment.mainQueue)
                .catchToEffect(HomeAction.deleteResponse)
        case .alertDismissed:
            state.alert = nil
            return .none
        case .onTapLogo:
            if UserDefaults.standard.bool(forKey: "Trainer") != false {
                state.isTrainer = true
            } else {
                state.isMakeTrainer = true
            }
            return .none
        }
    }
)
.binding()
