//
//  SignUpStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture

struct SignUpState: Equatable {
    @BindableState var email: String = ""
    @BindableState var password: String = ""
    @BindableState var confirmPassword: String = ""
    var isLoading: Bool = false
    var alert: AlertState<SignUpAction>?
    @BindableState var isRegister: Bool = false
    
    fileprivate mutating func text_validation() -> Bool {
        if self.email == "" || self.password == "" || self.confirmPassword == "" {
            self.alert = AlertState(title: TextState("エラー"), message: TextState("必須項目が入力されていません。"))
            return false
        }
        if self.password != self.confirmPassword {
            self.alert = AlertState(title: TextState("エラー"), message: TextState("パスワードが一致しません。"))
            return false
        }
        return true
    }
}

enum SignUpAction: BindableAction, Equatable {
    case binding(BindingAction<SignUpState>)
    case onTapSignUp
    case onTapSendMail
    case alertDismissed
    case sendMailResponse(Result<Bool, SendMailClient.Failure>)
    case signUpResponse(Result<Bool, SignUpClient.Failure>)
}

struct SignUpEnvironment {
    var sendMailClient: SendMailClient
    var signUpClient: SignUpClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let live = Self(
        sendMailClient: SendMailClient.live,
        signUpClient: SignUpClient.live,
        mainQueue: .main
    )
}

let signUpReducer: Reducer = Reducer<SignUpState, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onTapSignUp:
        /*
        if !state.text_validation() {
            return .none
        }
        state.isLoading = true
        return environment.signUpClient.fetch(state.email, state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignUpAction.signUpResponse)
        */
        state.isRegister = true
        return .none
    //MARK: - 確認メールを送信を押した後の処理
    case .onTapSendMail:
        if !state.text_validation() {
            return .none
        }
        state.isLoading = true
        return environment.sendMailClient.fetch(state.email, state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignUpAction.sendMailResponse)
        
    case .alertDismissed:
        state.alert = nil
        return .none
    //MARK: - 確認メールを送信した後のレスポンス(成功)を受ける処理
    case let .sendMailResponse(.success(response)):
        state.isLoading = false
        if response {
            state.alert = AlertState(title: TextState("確認"), message: TextState("確認メールを送信しました。"))
        } else {
            state.alert = AlertState(title: TextState("エラー"), message: TextState("このメールアドレスは既に確認されています。"))
        }
        return .none
    //MARK: - 確認メールを送信した後のレスポンス(失敗)を受ける処理
    case .sendMailResponse(.failure):
        state.isLoading = false
        state.alert = AlertState(title: TextState("エラー"), message: TextState("確認メールの送信を失敗しました。時間をおいてお試しください。"))
        return .none
    //MARK: - サインアップボタン押した後のレスポンス(成功)を受ける処理
    case let .signUpResponse(.success(response)):
        state.isLoading = false
        if !response {
            state.alert = AlertState(title: TextState("エラー"), message: TextState("メールアドレスが認証されていません。"))
        } else {
            state.isRegister = true
        }
        return .none
    //MARK: - サインアップボタン押した後のレスポンスを受ける処理
    case .signUpResponse(.failure):
        state.isLoading = false
        state.alert = AlertState(title: TextState("エラー"), message: TextState("エラーが発生しました。時間をおいてお試しください。"))
        return .none
    }
}
.binding()
