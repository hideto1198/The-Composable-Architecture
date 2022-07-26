//
//  FirebaseClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import ComposableArchitecture
import FirebaseFunctionsCombineSwift
import FirebaseFunctions
import Combine
import Foundation

let functions = Functions.functions()

struct FirebaseClient {
    var fetch: () -> Effect<[ReservationEntity], Failure>
    struct Failure: Error, Equatable {}
}


extension FirebaseClient {
    
    static let live = Self(
        fetch: {
            Effect.task {
                let data = try await functions.httpsCallable("test").call()
                var result: [ReservationEntity] = []
                if let data = data.data {
                    let datas: NSDictionary = (data as! NSDictionary)["data"] as! NSDictionary
                    for date in datas.allKeys {
                        let details: NSDictionary = datas[date]! as! NSDictionary
                        let reservation: ReservationEntity = ReservationEntity(
                            date: date as! String,
                            place: details["place"] as! String,
                            menu: details["menu"] as! String,
                            trainer_name: details["trainer"] as! String,
                            isTap: false
                        )
                        result.append(reservation)
                    }
                    return result
                } else {
                    return []
                }
            }
            .mapError{ _ in Failure() }
            .eraseToEffect()
        }
    )
}
