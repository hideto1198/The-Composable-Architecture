//
//  CodeReadStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import ComposableArchitecture

struct QRCodeEntity: Equatable {
    var planCounts: Int = 0
    var planMaxCounts: Int = 0
    var planName: String = ""
}
struct CodeReadState: Equatable {
    var qrData: QRCodeEntity = QRCodeEntity()
    var opacity: Double = 0.0
    var alert: AlertState<CodeReadAction>?
}

enum CodeReadAction: Equatable {
    case onRead(String)
    case alertDismissed
    case codeResponse(Result<Bool, CodeReadClient.Failure>)
}

struct CodeReadEnvironment {
    var codeReadClient: CodeReadClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(codeReadClient: CodeReadClient.live,
                           mainQueue: .main)
}

let codeReadReducer: Reducer = Reducer<CodeReadState, CodeReadAction, CodeReadEnvironment> { state, action, environment in
    switch action {
    case let .onRead(response):
        if !qrResponseCheck(response: response) {
            state.alert = AlertState(title: TextState("エラー"),
                                     message: TextState("このチケットは読み取ることができません。"))
            return .none
        } else {
            state.opacity = 1.0
            return environment.codeReadClient.fetch(response)
                .receive(on: environment.mainQueue)
                .catchToEffect(CodeReadAction.codeResponse)
        }
    case let .codeResponse(.success(result)):
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("チケットを追加しました"))
        return .none
    case .codeResponse(.failure):
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}

// MARK: - QRコードの読みより結果を解析する
private func qrResponseCheck(response: String) -> Bool {
    var result: Bool = true
    guard !response.isEmpty else { return false }
    
    guard response.components(separatedBy: ",").count == 4 else { return false }
    guard (Int(response.components(separatedBy: ",")[0])) != nil else { return false }
    guard (Int(response.components(separatedBy: ",")[1])) != nil else { return false }
    
    if !response.contains("BONAFIDE") {
        result = false
    }
    return result
}
