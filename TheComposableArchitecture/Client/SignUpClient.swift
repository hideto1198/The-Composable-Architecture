//
//  SignUpClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import Combine
import FirebaseAuth

struct SignUpClient {
    var fetch: (_ email: String, _ password: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {
        static func == (lhs: SignUpClient.Failure, rhs: SignUpClient.Failure) -> Bool {
            return true
        }
        var wrappedError: Error
    }
}

extension SignUpClient {
    static let live = SignUpClient(fetch: { email, password in
        Effect.task {
            let data = try await Auth.auth().signIn(withEmail: email, password: password)
            if let user = data.user {
                if user.isEmailVerified {
                    return true
                }
            } else {
                return false
            }
            return false
        }
        .mapError{ Failure(wrappedError: $0) }
        .eraseToEffect()
    })
}
/* エラーの詳細を受け取る
struct Failure: Error, Equatable {} →
struct Failure: Error, Equatable {
    var wrappedError: Error
}

.mapError{ _ in Failure() } →
.mapError(Failure(wrappedError: $0))
*/
