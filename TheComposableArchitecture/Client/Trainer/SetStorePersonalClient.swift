//
//  SetStorePersonalClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture
import FirebaseFunctions
import FirebaseAuth

struct SetStorePersonalClient {
    var fetch: (_ request: [String: Any]) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SetStorePersonalClient {
    static let live = SetStorePersonalClient(fetch: { request in
        Effect.task {
            let functions = Functions.functions()
            var request: [String: Any] = request
            request["id"] = Auth.auth().currentUser!.uid
            let response = try await functions.httpsCallable("set_trainer_store_day").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
