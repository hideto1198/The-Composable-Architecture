//
//  GetGymDetailsClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/30.
//

import Foundation
import ComposableArchitecture
import FirebaseFunctions

struct GetGymDetailsClient {
    var fetch: (_ request: [String: String]) -> Effect<[String: [GymDetailEntity]], Failure>
    struct Failure: Error, Equatable {}
}

extension GetGymDetailsClient {
    static let live = GetGymDetailsClient(fetch: { request in
        Effect.task {
            let functions = Functions.functions()
            var result: [GymDetailEntity] = []
            var response = try await functions.httpsCallable("get_gym_reservation_details").call(["data": request])
            let datas = (response.data) as! NSArray
            for data in datas {
                let _data: [String] = (data as! String).components(separatedBy: ",")
                result.append(GymDetailEntity(trainerName: _data[3],
                                              userName: _data[2],
                                              menuName: _data[1].contains("@") ? _data[1].description.components(separatedBy: "@")[0] : _data[1],
                                              placeName: _data[1].contains("@") ? _data[1].description.components(separatedBy: "@")[1] : "板垣店",
                                              times: _data[0].components(separatedBy: "~")))
            }
            return [request["day"]!: result]
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
