//
//  SendResetPasswordClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

struct SendResetPasswordClient {
    var fetch: (_ email: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SendResetPasswordClient {
    static let live = SendResetPasswordClient(fetch: { email in
        Effect.task {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
