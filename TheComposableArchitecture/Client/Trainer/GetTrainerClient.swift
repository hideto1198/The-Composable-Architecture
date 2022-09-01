//
//  GetTrainerClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct GetTrainerClient {
    var fetch: () -> Effect<[String], Failure>
    struct Failure: Error, Equatable {}
}

extension GetTrainerClient {
    static let live = GetTrainerClient(fetch: {
        Effect.task {
            let db = Firestore.firestore()
            var result: [String] = ["ジム全体","板垣店","二の宮店"]
            let response = try await db.collection("Trainer").getDocuments()
            for document in response.documents {
                result.append(document.get("name")! as! String)
            }
            
            return result
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
