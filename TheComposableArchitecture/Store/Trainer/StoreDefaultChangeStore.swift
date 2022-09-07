//
//  StoreDefaultChangeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/02.
//

import Foundation
import ComposableArchitecture

struct StoreDefaultChangeState: Equatable {
    var itagakiTrainers: [TrainerEntity] = []
    var ninomiyaTrainers: [TrainerEntity] = []
    var isLoading: Bool = false
    var trainerSelector: TrainerEntity? = nil
}

enum StoreDefaultChangeAction: Equatable {
    case getTrainerStore
    case getTrainerStoreResponse(Result<[TrainerEntity], GetTrainerStoreClient.Failure>)
    case onTapTrainer(TrainerEntity)
    case onTapRight
    case onTapLeft
    case onTapSave
    case onDisappear
    case onSave
    case setStoreResponse(Result<Bool, SetStoreClient.Failure>)
}

struct StoreDefaultChangeEnvironment {
    var getTrainerStoreClient: GetTrainerStoreClient
    var setStoreClient: SetStoreClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getTrainerStoreClient: GetTrainerStoreClient.live,
        setStoreClient: SetStoreClient.live,
        mainQueue: .main
    )
}

let storeDefaultChangeReducer: Reducer = Reducer<StoreDefaultChangeState, StoreDefaultChangeAction, StoreDefaultChangeEnvironment> { state, action, environment in
    enum StoreDefaultChangeId {}
    
    switch action {
    case .getTrainerStore:
        state.isLoading = true
        return environment.getTrainerStoreClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(StoreDefaultChangeAction.getTrainerStoreResponse)
            .cancellable(id: StoreDefaultChangeId.self)
    case let .getTrainerStoreResponse(.success(response)):
        state.isLoading = false
        state.itagakiTrainers = response.filter{ $0.store == "板垣店" }
        state.ninomiyaTrainers = response.filter{ $0.store == "二の宮店" }
        return .none
    case .getTrainerStoreResponse(.failure):
        state.isLoading = false
        return .none
    case let .onTapTrainer(trainer):
        state.trainerSelector = trainer
        return .none
    case .onTapRight:
        guard let store = state.trainerSelector?.store else { return .none }
        guard store != "板垣店" else { return .none }
        state.ninomiyaTrainers = state.ninomiyaTrainers.filter{ $0 != state.trainerSelector }
        state.trainerSelector!.store = "板垣店"
        state.itagakiTrainers.append(state.trainerSelector!)
        return .none
    case .onTapLeft:
        guard let store = state.trainerSelector?.store else { return .none }
        guard store != "二の宮店" else { return .none }
        state.itagakiTrainers = state.itagakiTrainers.filter{ $0 != state.trainerSelector }
        state.trainerSelector!.store = "二の宮店"
        state.ninomiyaTrainers.append(state.trainerSelector!)
        return .none
    case .onTapSave:
        return .none
    case .onDisappear:
        state.trainerSelector = nil
        return .cancel(id: StoreDefaultChangeId.self)
    case .onSave:
        var request: [String: [String: String]] = [:]
        state.isLoading = true
        for trainer in state.itagakiTrainers {
            request[trainer.trainerID] = [
                "place": "板垣店"
            ]
        }
        for trainer in state.ninomiyaTrainers {
            request[trainer.trainerID] = [
                "place": "二の宮店"
            ]
        }
        return environment.setStoreClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(StoreDefaultChangeAction.setStoreResponse)
    case .setStoreResponse(_):
        state.isLoading = false
        return .none
    }
}
