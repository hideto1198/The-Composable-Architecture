//
//  AuthenticationClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//
import ComposableArchitecture
import Combine
import FirebaseAuth
import Foundation

struct AuthenticationClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension AuthenticationClient {
    static let live = AuthenticationClient(fetch: {
        Effect.task {
            if Auth.auth().currentUser != nil && UserDefaults.standard.string(forKey: "first_launch") != nil {
                return true
            } else {
                return false
            }
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
