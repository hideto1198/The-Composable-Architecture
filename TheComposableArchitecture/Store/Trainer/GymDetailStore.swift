//
//  GymDetailStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/30.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct GymDetailEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var trainerName: String
    var userName: String
    var menuName: String
    var placeName: String
    var times: [String]
    var opacity: Double = 1.0
    
    init(trainerName: String, userName: String, menuName: String, placeName: String, times: [String]) {
        self.trainerName = trainerName
        self.userName = userName
        self.menuName = menuName
        self.placeName = placeName
        self.times = times
    }
}


struct GymDetailState: Equatable {
    var details: [GymDetailEntity] = []
    var isLoading: Bool = false
    var currentDate: String = ""
}

enum GymDetailAction: Equatable {
    case getGymDetails([String: String])
    case getGymDetailsResponse(Result<[String: [GymDetailEntity]], GetGymDetailsClient.Failure>)
    case cancelPlan(GymDetailEntity)
}

struct GymDetailEnvironment {
    var getGymDetailsClient: GetGymDetailsClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getGymDetailsClient: GetGymDetailsClient.live,
        mainQueue: .main
    )
}

let gymDetailReducer: Reducer = Reducer<GymDetailState, GymDetailAction, GymDetailEnvironment> { state, action, environment in
    let timer: Timer?
    enum GymDetailId {}
    switch action {
    case let .getGymDetails(request):
        state.isLoading = true
        state.details = []
        return environment.getGymDetailsClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(GymDetailAction.getGymDetailsResponse)
    case let .getGymDetailsResponse(.success(response)):
        if response.keys.first! == state.currentDate {
            state.details = response.values.first!
            state.isLoading = false
        }
        return .none
        
    case .getGymDetailsResponse(.failure):
        state.isLoading = false
        return .none
    // MARK: - 予定をキャンセルする
    case let .cancelPlan(detail):
        /*
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { time in
            withAnimation() {
                if state.details.filter{ $0.id == detail.id }.first!.opacity > 0.2 {
                    
                }
            }
        })
         */
        return .none
    }
}
