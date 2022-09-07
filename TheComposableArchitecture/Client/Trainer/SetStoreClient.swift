//
//  SetStoreClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture
import FirebaseFunctions
import FirebaseAuth

struct SetStoreClient {
    var fetch: (_ request: [String: [String: String]]) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SetStoreClient {
    static let live = SetStoreClient(fetch: { request in
        Effect.task {
            let functions = Functions.functions()
            let response = try await functions.httpsCallable("set_trainer_store").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
