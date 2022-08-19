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

/* ソートアルゴリズム
let dateFormatter: DateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy年MM月dd日"
let sorted_reservations = reservations.sorted(by: { ldate, rdate -> Bool in
    let left_date = ldate.date.components(separatedBy: " ")[0]
    let right_date = rdate.date.components(separatedBy: " ")[0]
    let left_date_date = dateFormatter.date(from: left_date)!
    let right_date_date = dateFormatter.date(from: right_date)!
    let left_time = ldate.date.components(separatedBy: " ")[1].components(separatedBy: "~")[0].replacingOccurrences(of: ":", with: "")
    let right_time = rdate.date.components(separatedBy: " ")[1].components(separatedBy: "~")[0].replacingOccurrences(of: ":", with: "")
    print("left_date: \(left_date_date) right_date: \(right_date_date) left_time: \(left_time) right_time: \(right_time)")
    return left_date_date <= right_date_date && Int(left_time)! <= Int(right_time)!
})
*/
