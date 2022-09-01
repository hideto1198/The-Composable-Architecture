//
//  ReservationStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ReservationEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var date: String = ""
    var place: String = ""
    var menu: String = ""
    var trainerName: String = ""
    var isTap: Bool = false
}

struct ReservationState: Equatable {
    var reservations: [ReservationEntity] = []
    var isLoading: Bool = false
}

enum ReservationAction: Equatable {
    case getReservation
    case reservationResponse(Result<[ReservationEntity], ReservationClient.Failure>)
    case onTapGesture(String)
    case reset
    case onTapDelete(ReservationEntity)
    case onDisappear
    
}

struct ReservationEnvironment {
    var reservationClient: ReservationClient
    var deleteClient: DeleteClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let reservationReducer: Reducer = Reducer<ReservationState, ReservationAction, ReservationEnvironment>{ state, action, environment in
    enum ReservationId {}
    
    switch action {
    case .getReservation:
        state.isLoading = true
        return environment.reservationClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(ReservationAction.reservationResponse)
            .cancellable(id: ReservationId.self)
    case let .reservationResponse(.success(response)):
        state.isLoading = false
        state.reservations = response
        return .none
    
    case .reservationResponse(.failure):
        state.isLoading = false
        return .none
        
    case let .onTapGesture(id):
        for i in state.reservations.indices {
            if state.reservations[i].id == id {
                state.reservations[i].isTap = state.reservations[i].isTap ? false : true
            } else {
                state.reservations[i].isTap = false
            }
        }
        return .none
    case .reset:
        state.reservations.removeAll()
        UserDefaults.standard.removeObject(forKey: "firstLaunch")
        return .none
    case let .onTapDelete(reservation):
        return .none
    case .onDisappear:
        return .cancel(id: ReservationId.self)
    }
}
