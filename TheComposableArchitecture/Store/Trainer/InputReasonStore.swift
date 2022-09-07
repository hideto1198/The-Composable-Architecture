//
//  InputReasonStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture

struct InputReasonState: Equatable {
    @BindableState var note: String = ""
    @BindableState var itemSelector: Int = 0
}

enum InputReasonAction: Equatable, BindableAction {
    case binding(BindingAction<InputReasonState>)
    case onTapDecision
    case onTapCancel
}

struct InputReasonEnvironment {
    static let live = Self()
}

let inputReasonReducer: Reducer = Reducer<InputReasonState, InputReasonAction, InputReasonEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onTapDecision:
        return .none
    case .onTapCancel:
        return .none
    }
}
.binding()
