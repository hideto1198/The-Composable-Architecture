//
//  InputReasonStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture

struct ReasonEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var time: String = ""
    var item: String = ""
    var note: String = ""
}

struct InputReasonState: Equatable {
    @BindableState var note: String = ""
    @BindableState var itemSelector: Int = 0
    var reasons: [ReasonEntity] = []
}

enum InputReasonAction: Equatable, BindableAction {
    case binding(BindingAction<InputReasonState>)
    case onTapDecision([String])
    case onTapCancel
}

struct InputReasonEnvironment {
    static let live = Self()
}

let inputReasonReducer: Reducer = Reducer<InputReasonState, InputReasonAction, InputReasonEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case let .onTapDecision(times):
        let items: [String] = ["体験","パーソナルトレーニング","ペアトレーニング","休み","その他"]
        for time in times {
            state.reasons.append(ReasonEntity(time: time,
                                              item: items[state.itemSelector],
                                              note: state.note))
        }
        state.note = ""
        state.itemSelector = 0
        return .none
    case .onTapCancel:
        state.note = ""
        state.itemSelector = 0
        return .none
    }
}
.binding()
