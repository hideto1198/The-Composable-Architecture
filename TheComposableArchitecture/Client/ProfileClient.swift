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
            UserDefaults.standard.set("\(request["firstName1"]!) \(request["lastName1"]!)", forKey: "userName")
            UserDefaults.standard.set("\(request["firstName2"]!) \(request["lastName2"]!)", forKey: "userKanaName")
            UserDefaults.standard.set("\(request["birthday"]!)", forKey: "birthday")
            UserDefaults.standard.set("\(request["sex"]!)", forKey: "sex")
            let response = try await functions.httpsCallable("set_user_profile").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
