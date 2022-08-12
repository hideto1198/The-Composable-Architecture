//
//  SignInClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import Combine
import Firebase
import FirebaseAuth

struct SignInClient {
    var fetch: (_ email: String, _ password: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SignInClient {
    static let live = SignInClient(fetch: { email, password in
        Effect.task {
            let data = try await Auth.auth().signIn(withEmail: email, password: password)
            if let user = data.user {
                debugPrint(user.uid)
                UserDefaults.standard.set(true, forKey: "first_launch")
            }
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
