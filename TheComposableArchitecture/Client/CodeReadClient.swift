//
//  CodeReadClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseFunctions

struct CodeReadClient {
    var fetch: (_ qrData: String) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension CodeReadClient {
    static let live = CodeReadClient(fetch: { qrData in
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            var request: [String: Any] = [
                "userID": userID,
                "plan_counts": qrData.components(separatedBy: ",")[0],
                "plan_max_counts": qrData.components(separatedBy: ",")[1],
                "plan_name": qrData.components(separatedBy: ",")[2]
            ]
            let response = try await functions.httpsCallable("set_ticket").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
