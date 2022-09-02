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
    var trainerID: String = ""
    var trainerName: String = ""
    var token: String = ""
    var imagePath: String = ""
    var store: String = ""
}

struct TrainerState: Equatable {
    var trainers: [TrainerEntity] = []
    var isLoading: Bool = false
}

enum TrainerAction: Equatable {
    case getTrainer([String: String])
    case trainerResponse(Result<[TrainerEntity], TrainerClient.Failure>)
    case onTapTrainer(TrainerEntity)
}

struct TrainerEnvironment {
    var trainerClient: TrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let trainerReducer: Reducer = Reducer<TrainerState, TrainerAction, TrainerEnvironment> { state, action, environment in
    switch action {
    case let .onTapTrainer(trainer):
        return .none
    case let .getTrainer(request):
        state.isLoading = true
        return environment.trainerClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerAction.trainerResponse)
    case let .trainerResponse(.success(response)):
        state.trainers = response
        state.isLoading = false
        return .none
    case .trainerResponse(.failure):
        state.isLoading = false
        return .none
    }
}
