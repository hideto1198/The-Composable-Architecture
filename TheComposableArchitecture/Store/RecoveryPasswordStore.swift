//
//  RecoveryPasswordStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import Foundation
import ComposableArchitecture

struct RecoveryPasswordState: Equatable {
    @BindableState var email: String = ""
    var isLoading: Bool = false
    var alert: AlertState<RecoveryPasswordAction>?
}

enum RecoveryPasswordAction: Equatable, BindableAction {
    case binding(BindingAction<RecoveryPasswordState>)
    case onTapSend
    case recoveryResponse(Result<Bool, SendResetPasswordClient.Failure>)
    case alertDismissed
}

struct RecoveryPasswordEnvironment {
    var sendResetPasswordClient: SendResetPasswordClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        sendResetPasswordClient: SendResetPasswordClient.live,
        mainQueue: .main
    )
}

let recoveryPasswordReducer: Reducer = Reducer<RecoveryPasswordState, RecoveryPasswordAction, RecoveryPasswordEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
        
    case .onTapSend:
        guard !state.email.isEmpty else {
            state.alert = AlertState(title: TextState("エラー"), message: TextState("必須項目が未入力です"))
            return .none
        }
        state.isLoading = true
        return environment.sendResetPasswordClient.fetch(state.email)
            .receive(on: environment.mainQueue)
            .catchToEffect(RecoveryPasswordAction.recoveryResponse)
    case .recoveryResponse(.success):
        state.isLoading = false
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("パスワード再設定用のメールを送信しました"))
        return .none
        
    case .recoveryResponse(.failure):
        state.isLoading = false
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
.binding()
