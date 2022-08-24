//
//  MakeTrainerStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import Foundation
import ComposableArchitecture

struct MakeTrainerState: Equatable {
    @BindableState var password: String = ""
    @BindableState var path_text: String = ""
    @BindableState var storeSelector: Int = 0
    var isLoading: Bool = false
    var alert: AlertState<MakeTrainerAction>?
}

enum MakeTrainerAction: Equatable, BindableAction {
    case binding(BindingAction<MakeTrainerState>)
    case onTapLogin
    case passwordResponse(Result<Bool, MakeTrainerClient.Failure>)
    case alertDismissed
}

struct MakeTrainerEnvironment {
    var makeTrainerClient: MakeTrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        makeTrainerClient: MakeTrainerClient.live,
        mainQueue: .main
    )
}

let makeTrainerReducer: Reducer = Reducer<MakeTrainerState, MakeTrainerAction, MakeTrainerEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onTapLogin:
        state.isLoading = true
        return environment.makeTrainerClient.fetch(state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(MakeTrainerAction.passwordResponse)
    case let .passwordResponse(.success(response)):
        state.isLoading = false
        if !response {
            state.alert = AlertState(title: TextState("エラー"),
                                     message: TextState("パスワードが違います"))
            return .none
        }
        debugPrint("確認成功")
        return .none
    case .passwordResponse(.failure):
        state.isLoading = false
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
.binding()
