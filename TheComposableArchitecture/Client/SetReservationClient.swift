//
//  SetReservationClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/18.
//

import Foundation
import ComposableArchitecture
import Combine
import FirebaseFunctions
import FirebaseAuth

struct SetReservationClient {
    var fetch: (_ reservations: [MakeReservationEntity]) -> Effect<[String: String], Failure>
    struct Failure: Error, Equatable {}
}

extension SetReservationClient {
    static let live = SetReservationClient(fetch: { reservations in
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            var request: [String: [[String: Any]]] = ["data": []]
            for reservation in reservations {
                request["data"]!.append([
                    "ID": "\(reservation.year)/\(reservation.month)/\(reservation.day)/\(reservation.timeFrom)/\(reservation.displayTime)",
                    "year": "\(reservation.year)",
                    "month": "\(reservation.month)",
                    "day": "\(reservation.day)",
                    "time1": "\(reservation.timeFrom)",
                    "time2": "\(reservation.timeTo)",
                    "show_time": "\(reservation.displayTime)",
                    "place": "\(reservation.placeName)",
                    "menu": "\(reservation.menuName)",
                    "trainer": "\(reservation.trainerName)",
                    "userID": userID,
                    "token": ""
                ])
            }
            let response = try await functions.httpsCallable("set_reservation_multi").call(request)
            let datas: [String: String] = ((response.data as! NSDictionary)["data"]) as! Dictionary
            return datas
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
