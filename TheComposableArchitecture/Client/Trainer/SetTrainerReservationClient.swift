//
//  SetTrainerReservationClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/09.
//

import Foundation
import ComposableArchitecture
import FirebaseFunctions
import FirebaseAuth

struct SetTrainerReservationClient {
    var fetch: (_ reservations: [MakeReservationEntity]) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {
        static func == (lhs: SetTrainerReservationClient.Failure, rhs: SetTrainerReservationClient.Failure) -> Bool {
            return true
        }
        
        var wrappedValue: Error
    }
}

extension SetTrainerReservationClient {
    static let live = SetTrainerReservationClient(fetch: { reservations in
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
            let data = try await functions.httpsCallable("set_reservation_trainer_new").call(request)
            return true
        }
        .mapError{ error in Failure(wrappedValue: error) }
        .eraseToEffect()
    })
}

