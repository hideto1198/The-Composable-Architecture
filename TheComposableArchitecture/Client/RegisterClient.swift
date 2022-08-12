//
//  RegisterClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import Combine
import FirebaseFirestore
import FirebaseAuth

struct RegisterClient {
    var fetch: (_ request: Dictionary<String, Any>) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension RegisterClient {
    static let live = RegisterClient(fetch: { request in
        Effect.task {
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser {
                try await db.collection("USERS").document("\(user.uid)").setData(request)
            } else {
                return false
            }
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
