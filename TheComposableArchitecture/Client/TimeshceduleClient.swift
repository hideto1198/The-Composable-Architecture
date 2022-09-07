//
//  TimeshceduleClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import ComposableArchitecture
import FirebaseFunctions
import FirebaseAuth
import Combine
import Foundation

struct TimescheduleClient {
    var fetch: () -> Effect<Dictionary<String, TimescheduleEntity>, Failure>
    struct Failure: Error, Equatable {}
}

extension TimescheduleClient {
    static let live = TimescheduleClient(fetch: {
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            let data = try await functions.httpsCallable("get_reservation_data").call(["userID": userID])
            var result: Dictionary<String, TimescheduleEntity> = [:]
            let datas: NSDictionary = (data.data as! NSDictionary)["data"] as! NSDictionary
            for time in datas.allKeys {
                let details: NSDictionary = datas[time]! as! NSDictionary
                let timeschedule: TimescheduleEntity = TimescheduleEntity(
                    time: time as! String,
                    state: details["state"] as! Int
                )
                result[time as! String] = timeschedule
            }
            return result
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
