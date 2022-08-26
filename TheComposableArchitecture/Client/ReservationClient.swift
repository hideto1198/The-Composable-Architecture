//
//  FirebaseClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import ComposableArchitecture
import FirebaseFunctions
import FirebaseAuth
import Combine
import Foundation

struct ReservationClient {
    var fetch: () -> Effect<[ReservationEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension ReservationClient {
    static let live = ReservationClient(fetch: {
            Effect.task {
                let functions = Functions.functions()
                let userID: String = Auth.auth().currentUser!.uid
                let data = try await functions.httpsCallable("test").call(["userID": userID])
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
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy年MM月dd日 H:m"
                    let sortedResult: [ReservationEntity] = result.sorted(by: { (ldate, rdate) -> Bool in
                        let leftDate = ldate.date.components(separatedBy: " ")[0]
                        let rightDate = rdate.date.components(separatedBy: " ")[0]
                        let leftTime = ldate.date.components(separatedBy: " ")[1].components(separatedBy: "~")[0]
                        let rightTime = rdate.date.components(separatedBy: " ")[1].components(separatedBy: "~")[0]
                        let leftDateTime = dateFormatter.date(from: "\(leftDate) \(leftTime)")!
                        let rightDateTime = dateFormatter.date(from: "\(rightDate) \(rightTime)")!
                        return leftDateTime <= rightDateTime
                    })
                    result = sortedResult
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
