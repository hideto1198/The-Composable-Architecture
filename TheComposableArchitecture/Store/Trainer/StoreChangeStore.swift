//
//  StoreChangeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/02.
//

import Foundation
import ComposableArchitecture

struct StoreChangeState: Equatable {
    @BindableState var viewSelector: Int = 0
    var storeDefaultChangeState: StoreDefaultChangeState = StoreDefaultChangeState()
    var storePersonalChangeState: StorePersonalChangeState = StorePersonalChangeState()
}

enum StoreChangeAction: Equatable, BindableAction {
    case binding(BindingAction<StoreChangeState>)
    case storeDefaultChangeAction(StoreDefaultChangeAction)
    case storePersonalChangeAction(StorePersonalChangeAction)
}

struct StoreChangeEnvironment {
    var getTrainerStoreClient: GetTrainerStoreClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getTrainerStoreClient: GetTrainerStoreClient.live,
        mainQueue: .main
    )
}

let storeChangeReducer: Reducer = Reducer<StoreChangeState, StoreChangeAction, StoreChangeEnvironment>.combine(
    storeDefaultChangeReducer.pullback(state: \StoreChangeState.storeDefaultChangeState,
                                       action: /StoreChangeAction.storeDefaultChangeAction,
                                       environment: { _ in StoreDefaultChangeEnvironment(getTrainerStoreClient: .live, mainQueue: .main)}),
    storePersonalChangeReducer.pullback(state: \StoreChangeState.storePersonalChangeState,
                                        action: /StoreChangeAction.storePersonalChangeAction,
                                        environment: { _ in StorePersonalChangeEnvironment(getTrainerStoreClient: .live, mainQueue: .main)}),
    Reducer { state, action, environment in
        switch action {
        case .binding:
            return .none
        case .storeDefaultChangeAction:
            return .none
        case .storePersonalChangeAction:
            return .none
            
        }
    }
)
.binding()
