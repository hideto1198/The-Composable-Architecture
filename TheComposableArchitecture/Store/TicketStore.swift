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
    var maxCounts: Int = 0
    var subName: String = ""
    var subCounts: Int = 0
    var subMaxCounts: Int = 0
}

struct TicketState: Equatable {
    var ticket: TicketEntity = TicketEntity()
    var isLoading: Bool = false
}

enum TicketAction: Equatable {
    case getTicket
    case ticketResponse(Result<TicketEntity, TicketClient.Failure>)
}

struct TicketEnvironment {
    var ticketClient: TicketClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let ticketReducer: Reducer = Reducer<TicketState, TicketAction, TicketEnvironment> { state, action, environment in
    
    switch action {
    case .getTicket:
        return environment.ticketClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TicketAction.ticketResponse)
        
    case let .ticketResponse(.success(response)):
        state.ticket = response
        return .none
        
    case .ticketResponse(.failure):
        return .none

    }
        
}



