//
//  SignOutClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

struct SignOutClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SignOutClient {
    static let live = SignOutClient(fetch: {
        Effect.task {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "firstLaunch")
            UserDefaults.standard.removeObject(forKey: "Trainer")
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
