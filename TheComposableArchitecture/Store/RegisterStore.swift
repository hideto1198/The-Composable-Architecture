//
//  RegisterStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture

struct RegisterState: Equatable {
    @BindableState var firstName1: String = ""  // 姓
    @BindableState var firstName2: String = ""  // セイ
    @BindableState var lastName1: String = ""   // 名
    @BindableState var lastName2: String = ""   // メイ
    @BindableState var sexSelector: Int = 0
    @BindableState var date: Date = Date()
    var isLoading: Bool = false
    var isHome: Bool = false
}

enum RegisterAction: BindableAction, Equatable {
    case binding(BindingAction<RegisterState>)
    case onTapRegister
    case registerResponse(Result<Bool, RegisterClient.Failure>)
}

struct RegisterEnvironment {
    var registerClient: RegisterClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let live = Self(
        registerClient: RegisterClient.live,
        mainQueue: .main
    )
}

let registerReducer: Reducer = Reducer<RegisterState, RegisterAction, RegisterEnvironment> { state, action, environemnt in
    switch action {
    case .binding:
        return .none
    case .onTapRegister:
        let request: Dictionary<String, Any> = [
            "BIRTHDAY": state.date,
            "FIRSTNAME_1": state.firstName1,
            "LASTNAME_1": state.lastName1,
            "FIRSTNAME_2": state.firstName2,
            "LASTNAME_2": state.lastName2,
            "SEX": state.sexSelector == 0 ? "" : state.sexSelector == 1 ? "男" : "女",
            "memo": "",
            "new_account": true,
            "pairID": "",
            "plan_counts": 0,
            "plan_max_counts": 0,
            "plan_name": "",
            "sub_plan_counts": 0,
            "sub_plan_max_counts": 0,
            "sub_plan_name": "",
            "token": ""
        ]
        state.isLoading = true
        return .none
    case let .registerResponse(.success(response)):
        state.isLoading = false
        return .none
    case .registerResponse(.failure):
        state.isLoading = false
        return .none
    }
}
.binding()
