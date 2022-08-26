//
//  DeleteClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseFunctions

struct DeleteClient {
    var fetch: (_ reservation: ReservationEntity) -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension DeleteClient {
    static let live = DeleteClient(fetch: { reservation in
        Effect.task {
            let functions = Functions.functions()
            let userID: String = Auth.auth().currentUser!.uid
            let times:[String] = [
                "9:00","9:30","10:00","10:30","11:00","11:30",
                "12:00","12:30","13:00","13:30","14:00","14:30",
                "15:00","15:30","16:00","16:30","17:00","17:30",
                "18:00","18:30","19:00","19:30","20:00","20:30",
                "21:00","21:30","22:00","22:30","23:00"
            ]
            let date = reservation.date.components(separatedBy: " ")[0]
            let year:String = date.components(separatedBy: "年")[0]
            let month:String = date.components(separatedBy: "年")[1].components(separatedBy: "月")[0]
            let day:String = date.components(separatedBy: "年")[1].components(separatedBy: "月")[1].components(separatedBy: "日")[0]
            let time = reservation.date.components(separatedBy: " ")[1]
            let showTime:String = time.components(separatedBy: "~")[1]
            let time1:String = time.components(separatedBy: "~")[0]
            let time2:String = times[times.firstIndex(of: showTime)!-1]
            let request: [String: Any] = [
                "year": "\(year)",
                "month": "\(month)",
                "day": "\(day)",
                "time1": "\(time1)",
                "time2": "\(time2)",
                "show_time": "\(showTime)",
                "userID": userID,
                "details": [
                    "place": "\(reservation.place)",
                    "menu": "\(reservation.menu)",
                    "trainer": "\(reservation.trainerName)"
                ]
            ]
            let data = try await functions.httpsCallable("delete_reservation").call(["delete_reservation_data": request])
            return true
        }
        .mapError { _ in Failure() }
        .eraseToEffect()
    })
}
