//
//  GetCustomerClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct GetCustomerClient {
    var fetch: () -> Effect<[UserEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension GetCustomerClient {
    static let live = GetCustomerClient(fetch: {
        Effect.task {
            let db = Firestore.firestore()
            var result: [UserEntity] = []
            let response = try await db.collection("USERS").getDocuments()
            for document in response.documents {
                result.append(UserEntity(userId: document.documentID,
                                         firstName1: document.get("FIRSTNAME_1") as! String,
                                         firstName2: document.get("FIRSTNAME_2") as! String,
                                         lastName1: document.get("LASTNAME_1") as! String,
                                         lastName2: document.get("LASTNAME_2") as! String,
                                         birthday: document.get("BIRTHDAY") as! String,
                                         sex: document.get("SEX") as! String,
                                         memo: document.get("memo") as! String,
                                         planName: document.get("plan_name") as! String,
                                         planCounts: document.get("plan_counts") as! Int,
                                         planMaxCounts: document.get("plan_max_counts") as! Int))
            }
            return result
        }
        .mapError { _ in Failure() }
        .eraseToEffect()
    })
}
