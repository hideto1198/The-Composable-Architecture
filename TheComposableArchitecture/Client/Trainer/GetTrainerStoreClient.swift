//
//  GetTrainerStoreClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/02.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct GetTrainerStoreClient {
    var fetch: () -> Effect<[TrainerEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension GetTrainerStoreClient {
    static let live = GetTrainerStoreClient(fetch: {
        Effect.task {
            var result: [TrainerEntity] = []
            let db = Firestore.firestore()
            let response = try await db.collection("Trainer").getDocuments()
            for document in response.documents {
                result.append(TrainerEntity(
                    trainerID: document.documentID,
                    trainerName: document.get("name") as! String,
                    store: document.get("place") as! String
                ))
            }
            return result
        }
        .mapError { _ in Failure() }
        .eraseToEffect()
    })
}
