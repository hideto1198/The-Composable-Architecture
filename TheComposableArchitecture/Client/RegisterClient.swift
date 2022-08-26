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
                UserDefaults.standard.set("\(request["FIRSTNAME_1"]!) \(request["LASTNAME_1"]!)", forKey: "userName")
                UserDefaults.standard.set("\(request["FIRSTNAME_2"]!) \(request["LASTNAME_2"]!)", forKey: "userKanaName")
                UserDefaults.standard.set("\(request["BIRTHDAY"]!)", forKey: "birthday")
                UserDefaults.standard.set("\(request["SEX"]!)", forKey: "sex")-
            } else {
                return false
            }
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
