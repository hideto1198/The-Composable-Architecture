//
//  SendMailClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

struct SendMailClient {
    var fetch: (_ email: String, _ password: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SendMailClient {
    static let live = SendMailClient(fetch: { email, password in
        Effect.task {
            let data = try await Auth.auth().signIn(withEmail: email, password: password)
            if let user = data.user {
                if !user.isEmailVerified {
                    try await user.sendEmailVerification()
                }else{
                    return false
                }
            } else {
                let data = try await Auth.auth().createUser(withEmail: email, password: password)
                if let user = data.user {
                    try await user.sendEmailVerification()
                }
            }
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
