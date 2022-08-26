//
//  SignInClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignInClient {
    var fetch: (_ email: String, _ password: String, _ withApple: Bool) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {
        static func == (lhs: SignInClient.Failure, rhs: SignInClient.Failure) -> Bool {
            return true
        }
        
        var wrappedValue: Error
    }
}

extension SignInClient {
    static let live = SignInClient(fetch: { email, password, withApple in
        Effect.task {
            if !withApple {
                try await Auth.auth().signIn(withEmail: email, password: password)
            }
            let db = Firestore.firestore()
            let userID: String = Auth.auth().currentUser!.uid
            let response = try await db.collection("USERS").document("\(userID)").getDocument()
            if response.exists {
                UserDefaults.standard.set("\(response.get("firstName1")!) \(response.get("lastName1")!)", forKey: "userName")
                UserDefaults.standard.set("\(response.get("firstName2")!) \(response.get("lastName2")!)", forKey: "userKanaName")
                UserDefaults.standard.set("\(response.get("birthday")!)", forKey: "birthday")
                UserDefaults.standard.set("\(response.get("sex")!)", forKey: "sex")
                return true
            } else {
                return false
            }
        }
        .mapError{ error in Failure(wrappedValue: error) }
        .eraseToEffect()
    })
}
