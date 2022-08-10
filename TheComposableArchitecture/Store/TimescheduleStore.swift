//
//  TimescheduleStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import Foundation
import ComposableArchitecture

struct TimescheduleEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var time: String = ""
    var state: Int = 0
    var isTap: Bool = false
}

struct TimescheduleState: Equatable {
    // var times: [TimescheduleEntity] = []
    var times: Dictionary<String, TimescheduleEntity> = [:]
    var isLoading: Bool = false
}

enum TimescheduleAction: Equatable {
    case getTimeschedule
    case timescheduleResponse(Result<Dictionary<String, TimescheduleEntity>, TimescheduleClient.Failure>)
    case onTapTime(String)
}

struct TimescheduleEnvironment {
    var timescheduleClient: TimescheduleClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let timescheduleReducer: Reducer = Reducer<TimescheduleState, TimescheduleAction, TimescheduleEnvironment> { state, action, environment in
    switch action {
    case let .onTapTime(index):
        return .none
    
    case .getTimeschedule:
        state.isLoading = true
        return environment.timescheduleClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(TimescheduleAction.timescheduleResponse)
        
    case let .timescheduleResponse(.success(response)):
        state.times = response
        state.isLoading = false
        return .none
        
    case .timescheduleResponse(.failure):
        state.isLoading = false
        return .none
    }
}
