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
    @BindableState var isTrainer: Bool = false
}

enum MakeTrainerAction: Equatable, BindableAction {
    case binding(BindingAction<MakeTrainerState>)
    case onTapLogin
    case passwordResponse(Result<Bool, MakeTrainerClient.Failure>)
    case alertDismissed
    case onPasswordChanged(String)
    case onPathChanged(String)
    case setTrainerResponse(Result<Bool, SetTrainerClient.Failure>)
}

struct MakeTrainerEnvironment {
    var makeTrainerClient: MakeTrainerClient
    var setTrainerClient: SetTrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        makeTrainerClient: MakeTrainerClient.live,
        setTrainerClient: SetTrainerClient.live,
        mainQueue: .main
    )
}

let makeTrainerReducer: Reducer = Reducer<MakeTrainerState, MakeTrainerAction, MakeTrainerEnvironment> { state, action, environment in
    switch action {
    case let .onPasswordChanged(password):
        state.password = password.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "")
        return .none
    case let .onPathChanged(path):
        state.path_text = path.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "")
        return .none
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
        let request: [String: String] = [
            "name": UserDefaults.standard.string(forKey: "userName")!,
            "path_name": state.path_text,
            "token": "",
            "place": state.storeSelector == 0 ? "板垣店" : "二の宮店"
        ]
        state.isLoading = true
        return environment.setTrainerClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(MakeTrainerAction.setTrainerResponse)
        
    case .passwordResponse(.failure):
        state.isLoading = false
        return .none
        
    case .setTrainerResponse(.success):
        state.isLoading = false
        state.isTrainer = true
        return .none
        
    case .setTrainerResponse(.failure):
        state.isLoading = false
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
.binding()
