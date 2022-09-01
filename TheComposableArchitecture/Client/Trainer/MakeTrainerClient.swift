//
//  MakeTrainerClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseFirestore

struct MakeTrainerClient {
    var fetch: (_ password: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension MakeTrainerClient {
    static let live = MakeTrainerClient(fetch: { password in
        Effect.task {
            let db = Firestore.firestore()
            let response = try await db.collection("Data").document("Key").getDocument()
            if password == response.get("password")! as! String {
                return true
            } else {
                return false
            }
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
