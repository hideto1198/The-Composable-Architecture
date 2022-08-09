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
    var fetch: () -> Effect<[TrainerEntity], Failure>
    struct Failure: Error, Equatable {}
}

extension TrainerClient {
    static let live = TrainerClient(fetch: {
        Effect.task {
            let functions = Functions.functions()
            let data = try await functions.httpsCallable("get_trainers").call()
            var result: [TrainerEntity] = []
            if let data = data.data {
                let datas: NSDictionary = (data as! NSDictionary)["data"] as! NSDictionary
                for trainer_id in datas.allKeys {
                    let details: NSDictionary = datas[trainer_id]! as! NSDictionary
                    let trainer: TrainerEntity = TrainerEntity(
                        trainer_id: trainer_id as! String,
                        trainer_name: details["trainer_name"] as! String,
                        token: details["token"] as! String,
                        image_path: details["image_path"] as! String
                    )
                    
                    result.append(trainer)
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
