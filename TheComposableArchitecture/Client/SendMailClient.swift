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
    struct Failure: Error, Equatable {
        static func == (lhs: SendMailClient.Failure, rhs: SendMailClient.Failure) -> Bool {
            return true
        }
        
        var wrappedValue: Error
    }
}

extension SendMailClient {
    static let live = SendMailClient(fetch: { email, password in
        Effect.task {
            try Auth.auth().signOut()
            do {
                let auth = try await Auth.auth().signIn(withEmail: email, password: password)
                try await auth.user.reload()
                if !auth.user.isEmailVerified {
                    do {
                        try await auth.user.sendEmailVerification()
                    } catch {
                        throw Failure(wrappedValue: error)
                    }
                } else {
                    return false
                }
            } catch {
                let auth = try await Auth.auth().createUser(withEmail: email, password: password)
                try await auth.user.sendEmailVerification()
            }
            return true
        }
        .mapError{ error in Failure(wrappedValue: error) }
        .eraseToEffect()
    })
}
