//
//  SignUpWithAppleClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/15.
//

import Foundation
import ComposableArchitecture
import Combine
import AuthenticationServices


struct SignUpWithAppleClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SignUpWithAppleClient {
    static let live = SignUpWithAppleClient(fetch: {
        Effect.task {
            
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
