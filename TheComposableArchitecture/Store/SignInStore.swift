//
//  SignInStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct SignInState: Equatable {
    @BindableState var isRecover: Bool = false
    @BindableState var isHome: Bool = false
    @BindableState var email: String = ""
    @BindableState var password: String = ""
    var isLoading: Bool = false
    var alert: AlertState<SignInAction>?
}

enum SignInAction: BindableAction, Equatable {
    case binding(BindingAction<SignInState>)
    case onTapSignIn
    case signInResponse(Result<Bool, SignInClient.Failure>)
    case alertDismissed
    case onTapWithApple(Bool)
    case onTapRecovery
    case onTextChanged(String)
}

struct SignInEnvironment {
    var signInClient: SignInClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signInReducer: Reducer = Reducer<SignInState, SignInAction, SignInEnvironment> { state, action, environment in
    switch action {
    case let .onTextChanged(password):
        state.password = password.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "")
        return .none
    case .binding:
        return .none
    case .onTapSignIn:
        state.isLoading = true
        return environment.signInClient.fetch(state.email, state.password, false)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignInAction.signInResponse)
    case let .signInResponse(.success(response)):
        state.isLoading = false
        if !response {
            state.alert = AlertState(title: TextState("エラー"),
                                     message: TextState("サインアップが完了していません"))
            return .none
        }
        state.isHome = true
        return .none
        
    case let .signInResponse(.failure(response)):
        state.isLoading = false
        state.alert = AlertState(title: TextState("エラー"),
                                 message: TextState("メールアドレスまたはパスワードが間違っています"))
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    case let .onTapWithApple(result):
        if result {
            state.isLoading = true
            return environment.signInClient.fetch(state.email, state.password, true)
                .receive(on: environment.mainQueue)
                .catchToEffect(SignInAction.signInResponse)
        } else {
            state.alert = AlertState(title: TextState("エラー"),
                                     message: TextState("サインアップが完了していません。"))
        }
        return .none
    case .onTapRecovery:
        state.isRecover = true
        return .none
    }
}
.binding()
