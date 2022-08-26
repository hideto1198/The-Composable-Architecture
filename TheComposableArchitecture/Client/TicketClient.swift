//
//  TicketStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/27.
//

import ComposableArchitecture
import FirebaseFunctions
import Combine
import Foundation
import FirebaseAuth

struct TicketClient {
    var fetch: () -> Effect<TicketEntity, Failure>
    struct Failure: Error, Equatable {}
}

extension TicketClient {
    static let live = TicketClient(fetch: {
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            let data = try await functions.httpsCallable("get_plan").call(["userID": userID])
            var result: TicketEntity = TicketEntity()
            if let data = data.data {
                let datas: NSDictionary = (data as! NSDictionary)["data"] as! NSDictionary
                result = TicketEntity(
                    name: datas["plan_name"] as! String,
                    counts: datas["plan_counts"] as! Int,
                    maxCounts: datas["max_plan_counts"] as! Int,
                    subName: datas["sub_plan_name"] as! String,
                    subCounts: datas["sub_plan_counts"] as! Int,
                    subMaxCounts: datas["sub_plan_max_counts"] as! Int
                )
                return result
            }else{
                return result
            }
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
