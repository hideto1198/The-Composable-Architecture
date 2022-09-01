//
//  SetTrainerClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore
import FirebaseAuth

struct SetTrainerClient {
    var fetch: (_ request: [String: String]) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SetTrainerClient {
    static let live = SetTrainerClient(fetch: { request in
        Effect.task {
            let db = Firestore.firestore()
            let userID: String = Auth.auth().currentUser!.uid
            db.collection("Trainer").document(userID).setData(request)
            UserDefaults.standard.set(true, forKey: "Trainer")
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
