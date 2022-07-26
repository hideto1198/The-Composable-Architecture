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
}

enum RootAction {
    case reservation(ReservationAction)
    case onAppear
}

struct RootEnvironment {
    var fact: FirebaseClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        fact: .live,
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
                  environment: { .init(fact: $0.fact, mainQueue: $0.mainQueue)})
)
