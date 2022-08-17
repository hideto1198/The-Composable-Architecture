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
    @BindableState var isHome: Bool = false
    var isLoading: Bool = false
    var alert: AlertState<RegisterAction>?
    
    fileprivate mutating func data_validation() -> Bool {
        if self.firstName1.isEmpty || self.firstName2.isEmpty || self.lastName1.isEmpty || self.lastName2.isEmpty {
            self.alert = AlertState(title: TextState("エラー"), message: TextState("必須項目が未入力です。"))
            return false
        } else {
            return true
        }
    }
}

enum RegisterAction: BindableAction, Equatable {
    case binding(BindingAction<RegisterState>)
    case onTapRegister
    case registerResponse(Result<Bool, RegisterClient.Failure>)
    case alertDismissed
    case navigateToHome
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
        if !state.data_validation() {
            return .none
        }
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        let request: Dictionary<String, Any> = [
            "BIRTHDAY": dateFormatter.string(from: state.date),
            "FIRSTNAME_1": state.firstName1,
            "LASTNAME_1": state.lastName1,
            "FIRSTNAME_2": state.firstName2,
            "LASTNAME_2": state.lastName2,
            "SEX": state.sexSelector == 0 ? "" : state.sexSelector == 1 ? "男" : "女",
            "memo": "",
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
        return environemnt.registerClient.fetch(request)
            .receive(on: environemnt.mainQueue)
            .catchToEffect(RegisterAction.registerResponse)
    case let .registerResponse(.success(response)):
        state.isLoading = false
        if response {
            state.alert = AlertState(title: TextState("確認"),
                                     message: TextState("登録が完了しました"),
                                     dismissButton: .default(TextState("OK"), action: .send(.navigateToHome)))
        }
        return .none
    case .registerResponse(.failure):
        state.isLoading = false
        state.alert = AlertState(title: TextState("エラー"),
                                 message: TextState("申し訳ございません、エラーが発生しました。時間をおいて再度お試しください。"))
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    case .navigateToHome:
        state.alert = nil
        state.isHome = true
        return .none
    }
}
.binding()
