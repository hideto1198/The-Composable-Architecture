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
    var fetch: (_ reservations: [MakeReservationEntity]) -> Effect<Bool, Failure>
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
                    "ID": "\(reservation.year)/\(reservation.month)/\(reservation.day)/\(reservation.time_from)/\(reservation.display_time)",
                    "year": "\(reservation.year)",
                    "month": "\(reservation.month)",
                    "day": "\(reservation.day)",
                    "time1": "\(reservation.time_from)",
                    "time2": "\(reservation.time_to)",
                    "show_time": "\(reservation.display_time)",
                    "place": "\(reservation.place_name)",
                    "menu": "\(reservation.menu_name)",
                    "trainer": "\(reservation.trainer_name)",
                    "userID": userID,
                    "token": ""
                ])
            }
            let data = try await functions.httpsCallable("set_reservation_multi").call(request)
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
