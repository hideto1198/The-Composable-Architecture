//
//  WithdrawClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/23.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseFunctions

struct WithdrawClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {
        static func == (lhs: WithdrawClient.Failure, rhs: WithdrawClient.Failure) -> Bool {
            return true
        }
        
        var wrappedValue: Error
    }
}

extension WithdrawClient {
    static let live = WithdrawClient(fetch: {
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            let response = try await functions.httpsCallable("delete_user").call(["userID": userID])
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "first_launch")
            UserDefaults.standard.removeObject(forKey: "user_name")
            UserDefaults.standard.removeObject(forKey: "user_kana_name")
            UserDefaults.standard.removeObject(forKey: "sex")
            UserDefaults.standard.removeObject(forKey: "birthday")
            return true
        }
        .mapError{ error in Failure(wrappedValue: error) }
        .eraseToEffect()
    })
}
