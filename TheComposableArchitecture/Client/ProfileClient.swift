//
//  ProfileClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseFunctions

struct ProfileClient {
    var fetch: (_ request: [String: String]) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension ProfileClient {
    static let live = ProfileClient(fetch: { _request in
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            var request: [String: String] = _request
            request["userID"] = userID
            UserDefaults.standard.set("\(request["FIRSTNAME_1"]!) \(request["LASTNAME_1"]!)", forKey: "user_name")
            UserDefaults.standard.set("\(request["FIRSTNAME_2"]!) \(request["LASTNAME_2"]!)", forKey: "user_kana_name")
            UserDefaults.standard.set("\(request["BIRTHDAY"]!)", forKey: "birthday")
            UserDefaults.standard.set("\(request["SEX"]!)", forKey: "sex")
            let response = try await functions.httpsCallable("set_user_profile").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
