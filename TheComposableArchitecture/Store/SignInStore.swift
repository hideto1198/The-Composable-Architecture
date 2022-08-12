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
    @BindableState var email: String = ""
    @BindableState var password: String = ""
    var isLoading: Bool = false
    @BindableState var isHome: Bool = false
    var alert: AlertState<SignInAction>?
}

enum SignInAction: BindableAction, Equatable {
    case binding(BindingAction<SignInState>)
    case onTapSignIn
    case signInResponse(Result<Bool, SignInClient.Failure>)
    case alertDismissed
}

struct SignInEnvironment {
    var signInClient: SignInClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signInReducer: Reducer = Reducer<SignInState, SignInAction, SignInEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onTapSignIn:
        state.isLoading = true
        return environment.signInClient.fetch(state.email, state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignInAction.signInResponse)
    case let .signInResponse(.success(response)):
        state.isLoading = false
        state.isHome = true
        return .none
        
    case .signInResponse(.failure):
        state.isLoading = false
        state.alert = AlertState(title: TextState("エラー"),
                                 message: TextState("メールアドレスまたはパスワードが間違っています"))
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
.binding()
