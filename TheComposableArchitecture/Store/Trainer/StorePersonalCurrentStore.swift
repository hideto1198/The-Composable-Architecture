//
//  StorePersonalCurrentStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture

struct StoreCurrentEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var time: String = ""
    var store: String = ""
}
struct StorePersonalCurrentState: Equatable {
    var details: [StoreCurrentEntity] = []
}

enum StorePersonalCurrentAction: Equatable {
    case getStoreCurrent(Date?)
    case getStoreCurrentResponse(Result<[StoreCurrentEntity], GetStoreCurrentClient.Failure>)
    case onDisappear
}

struct StorePersonalCurrentEnvironment {
    var getStoreCurrentClient: GetStoreCurrentClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getStoreCurrentClient: GetStoreCurrentClient.live,
        mainQueue: .main
    )
}

let storePersonalCurrentReducer: Reducer = Reducer<StorePersonalCurrentState, StorePersonalCurrentAction, StorePersonalCurrentEnvironment> { state, action, environment in
    enum StorePersonalCurrentId {}
    
    switch action {
        
    case let .getStoreCurrent(date):
        return environment.getStoreCurrentClient.fetch(date)
            .receive(on: environment.mainQueue)
            .catchToEffect(StorePersonalCurrentAction.getStoreCurrentResponse)
            .cancellable(id: StorePersonalCurrentId.self)
    case let .getStoreCurrentResponse(.success(response)):
        state.details = response
        return .none
    case .getStoreCurrentResponse(.failure):
        return .none
    case .onDisappear:
        return .cancel(id: StorePersonalCurrentId.self)
    }
}
