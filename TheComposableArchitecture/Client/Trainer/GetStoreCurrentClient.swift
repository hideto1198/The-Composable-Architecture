//
//  GetStoreCurrentClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore
import FirebaseAuth
struct GetStoreCurrentClient {
    var fetch: (_ date: Date?) -> Effect<[StoreCurrentEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension GetStoreCurrentClient {
    static let live = GetStoreCurrentClient(fetch: { date in
        Effect.task {
            let db = Firestore.firestore()
            var result: [StoreCurrentEntity] = []
            let trainerID: String = Auth.auth().currentUser!.uid
            var dateFormatter: DateFormatter {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateFormat = "yyyy年MM月dd日"
                return dateFormatter
            }
            var targetDate: String = ""
            if let date = date {
                targetDate = dateFormatter.string(from: date)
            } else {
                targetDate = dateFormatter.string(from: Date())
            }
            let response = try await db.collection("Trainer").document(trainerID).collection("store_info").document(targetDate).getDocument()
            if let data = response.data() {
                for key in data.keys {
                    result.append(StoreCurrentEntity(time: String("00000\(key)".suffix(5)), store: data[key]! as! String))
                }
                result = result.sorted(by: { ltime, rtime in
                    return ltime.time < rtime.time
                })
            }
            return result
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
