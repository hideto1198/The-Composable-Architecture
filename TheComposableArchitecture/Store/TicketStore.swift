//
//  HomeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/27.
//

import Foundation
import ComposableArchitecture


struct TicketEntity: Equatable {
    var name: String = ""
    var counts: Int = 0
    var max_counts: Int = 0
    var sub_name: String = ""
    var sub_counts: Int = 0
    var sub_max_counts: Int = 0
}

struct TicketState: Equatable {
    var ticket: TicketEntity = TicketEntity()
    var isLoading: Bool = false
    var isMenu: Bool = false
}

enum TicketAction {
    case getTicket
    case ticketResponse(Result<TicketEntity, TicketClient.Failure>)
    case onMenuTap
}

struct TicketEnvironment {
    var ticketClient: TicketClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let ticketReducer: Reducer = Reducer<TicketState, TicketAction, TicketEnvironment> { state, action, environment in
    switch action {
    case .getTicket:
        debugPrint("こここ")
        return environment.ticketClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TicketAction.ticketResponse)
        
    case let .ticketResponse(.success(response)):
        state.ticket = response
        return .none
        
    case .ticketResponse(.failure):
        
        return .none
        
    case .onMenuTap:
        state.isMenu = true
        return .none
    }
}



