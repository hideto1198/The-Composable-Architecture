//
//  StorePersonalChangeStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/02.
//

import Foundation
import ComposableArchitecture

struct StorePersonalChangeState: Equatable {
    @BindableState var dateSelector: Date = Date()
    @BindableState var timeFromSelector: Int = 0
    @BindableState var timeToSelector: Int = 0
    var storePersonalCurrentState: StorePersonalCurrentState = StorePersonalCurrentState()
    var itagakiTrainers: [TrainerEntity] = []
    var ninomiyaTrainers: [TrainerEntity] = []
    var isLoading: Bool = false
    var trainerSelector: TrainerEntity? = nil
}

enum StorePersonalChangeAction: Equatable, BindableAction {
    case binding(BindingAction<StorePersonalChangeState>)
    case getTrainerStore
    case getTrainerStoreResponse(Result<[TrainerEntity], GetTrainerStoreClient.Failure>)
    case onTapTrainer(TrainerEntity)
    case onTapRight
    case onTapLeft
    case onTapSave
    case onDisappear
    case onChangeTimeFrom
    case onChangeTimeTo
    case storePersonalCurrentAction(StorePersonalCurrentAction)
    case onSave
    case setStorePersonalResponse(Result<Bool, SetStorePersonalClient.Failure>)
}

struct StorePersonalChangeEnvironment {
    var getTrainerStoreClient: GetTrainerStoreClient
    var setStorePersonalClient: SetStorePersonalClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getTrainerStoreClient: GetTrainerStoreClient.live,
        setStorePersonalClient: SetStorePersonalClient.live,
        mainQueue: .main
    )
}

let storePersonalChangeReducer: Reducer = Reducer<StorePersonalChangeState, StorePersonalChangeAction, StorePersonalChangeEnvironment>.combine(
    storePersonalCurrentReducer.pullback(state: \StorePersonalChangeState.storePersonalCurrentState,
                                         action: /StorePersonalChangeAction.storePersonalCurrentAction,
                                         environment: { _ in StorePersonalCurrentEnvironment(getStoreCurrentClient: .live, mainQueue: .main) }),
    Reducer { state, action, environment in
        enum StorePersonalChangeId {}
        
        switch action {
        case .binding:
            return .none
        case .getTrainerStore:
            return environment.getTrainerStoreClient.fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(StorePersonalChangeAction.getTrainerStoreResponse)
                .cancellable(id: StorePersonalChangeId.self)
        case let .getTrainerStoreResponse(.success(response)):
            state.itagakiTrainers = response.filter{ $0.store == "板垣店" && $0.trainerName == UserDefaults.standard.string(forKey: "userName")! }
            state.ninomiyaTrainers = response.filter{ $0.store == "二の宮店" && $0.trainerName == UserDefaults.standard.string(forKey: "userName")! }
            return .none
        case .getTrainerStoreResponse(.failure):
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
            return .cancel(id: StorePersonalChangeId.self)
        case .onChangeTimeFrom:
            if state.timeFromSelector > state.timeToSelector {
                state.timeToSelector = state.timeFromSelector
            }
            return .none
        case .onChangeTimeTo:
            if state.timeToSelector < state.timeFromSelector {
                state.timeFromSelector = state.timeToSelector
            }
            return .none
        case .storePersonalCurrentAction:
            return .none
        
        case .onSave:
            state.isLoading = true
            var dateFormatter: DateFormatter {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateFormat = "yyyy年MM月dd日"
                return dateFormatter
            }
            var request: [String: Any] = [
                "details": [:]
            ]
            request["date"] = dateFormatter.string(from: state.dateSelector)
            var dates: [String: String] = [:]
            for time in getTimes(timeFromIndex: state.timeFromSelector, timeToIndex: state.timeToSelector) {
                dates[time] = state.itagakiTrainers.isEmpty ? "二の宮店" : "板垣店"
            }
            request["details"] = dates
            return environment.setStorePersonalClient.fetch(request)
                .receive(on: environment.mainQueue)
                .catchToEffect(StorePersonalChangeAction.setStorePersonalResponse)
        case .setStorePersonalResponse(_):
            state.isLoading = false
            return Effect(value: StorePersonalChangeAction.storePersonalCurrentAction(.getStoreCurrent(state.dateSelector)))
        }
    }
)
.binding()

private func getTimes(timeFromIndex: Int, timeToIndex: Int) -> [String] {
    let times: [String] = [
        "9:00","9:30","10:00","10:30","11:00","11:30",
        "12:00","12:30","13:00","13:30","14:00","14:30",
        "15:00","15:30","16:00","16:30","17:00","17:30",
        "18:00","18:30","19:00","19:30","20:00","20:30",
        "21:00","21:30","22:00","22:30"
    ]
    var result: [String] = []
    for i in (timeFromIndex ... timeToIndex) {
        result.append(times[i])
    }
    return result
}

