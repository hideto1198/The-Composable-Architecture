//
//  TrainerStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/09.
//

import Foundation
import ComposableArchitecture

struct TrainerEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var trainer_id: String = ""
    var trainer_name: String = ""
    var token: String = ""
    var image_path: String = ""
}

struct TrainerState: Equatable {
    var trainers: [TrainerEntity] = []
}

enum TrainerAction: Equatable {
    case getTrainer
    case trainerResponse(Result<[TrainerEntity], TrainerClient.Failure>)
    case onTapTrainer
}

struct TrainerEnvironment {
    var trainerClient: TrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let trainerReducer: Reducer = Reducer<TrainerState, TrainerAction, TrainerEnvironment> { state, action, environment in
    switch action {
    case .onTapTrainer:
        return .none
    case .getTrainer:
        return environment.trainerClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerAction.trainerResponse)
    case let .trainerResponse(.success(response)):
        state.trainers = response
        return .none
    case .trainerResponse(.failure):
        return .none
    }
}
