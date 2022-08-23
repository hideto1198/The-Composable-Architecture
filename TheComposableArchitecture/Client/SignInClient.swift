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
                UserDefaults.standard.set("\(response.get("FIRSTNAME_1")!) \(response.get("LASTNAME_1")!)", forKey: "user_name")
                UserDefaults.standard.set("\(response.get("FIRSTNAME_2")!) \(response.get("LASTNAME_2")!)", forKey: "user_kana_name")
                UserDefaults.standard.set("\(response.get("BIRTHDAY")!)", forKey: "birthday")
                UserDefaults.standard.set("\(response.get("SEX")!)", forKey: "sex")
                return true
            } else {
                return false
            }
        }
        .mapError{ error in Failure(wrappedValue: error) }
        .eraseToEffect()
    })
}
