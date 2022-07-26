//
//  TrainerClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/09.
//

import ComposableArchitecture
import FirebaseFunctions
import Combine
import Foundation

struct TrainerClient {
    var fetch: (_ request: [String: String]) -> Effect<[TrainerEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension TrainerClient {
    static let live = TrainerClient(fetch: { request in
        Effect.task {
            let functions = Functions.functions()
            let data = try await functions.httpsCallable("get_trainers").call(request)
            var result: [TrainerEntity] = []
            let datas: NSDictionary = (data.data as! NSDictionary)["data"] as! NSDictionary
            for trainer_id in datas.allKeys {
                let details: NSDictionary = datas[trainer_id]! as! NSDictionary
                let trainer: TrainerEntity = TrainerEntity(
                    trainerID: trainer_id as! String,
                    trainerName: details["name"] as! String,
                    token: details["token"] as! String,
                    imagePath: details["path_name"] as! String
                )
                
                result.append(trainer)
            }
            return result
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    }
    )
}
