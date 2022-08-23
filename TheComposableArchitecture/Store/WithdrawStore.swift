//
//  WithdrawStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/23.
//

import Foundation
import ComposableArchitecture

struct WithdrawState: Equatable {
    @BindableState var withdraw_text: String = ""
    var alert: AlertState<WithdrawAction>?
    @BindableState var isLaunch: Bool = false
    var isLoading: Bool = false
}

enum WithdrawAction: BindableAction, Equatable {
    case binding(BindingAction<WithdrawState>)
    case confirmWithdraw
    case withdrawResponse(Result<Bool, WithdrawClient.Failure>)
    case alertDismissed
    case onWithdraw
    case navigateLaunch
}

struct WithdrawEnvironment {
    var withdrawCleint: WithdrawClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        withdrawCleint: .live,
        mainQueue: .main
    )
}

let withdrawReducer: Reducer = Reducer<WithdrawState, WithdrawAction, WithdrawEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .confirmWithdraw:
        guard state.withdraw_text == "退会する" else { return .none }
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("退会します。"),
                                 primaryButton: .cancel(TextState("いいえ")),
                                 secondaryButton: .destructive(TextState("はい"), action: .send(.onWithdraw)))
        return .none
    case .onWithdraw:
        state.isLoading = true
        return environment.withdrawCleint.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(WithdrawAction.withdrawResponse)
    case .withdrawResponse(.success):
        state.isLoading = false
        state.alert = AlertState(title: TextState("確認"), message: TextState("退会しました"), dismissButton: .default(TextState("はい"), action: .send(.navigateLaunch)))
        return .none
    case let .withdrawResponse(.failure(error)):
        debugPrint("error: \(error)")
        state.isLoading = false
        return .none
    case .navigateLaunch:
        state.alert = nil
        state.isLaunch = true
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
.binding()
