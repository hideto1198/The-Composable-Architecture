//
//  TrainerHomeState.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import Foundation
import ComposableArchitecture

struct TrainerHomeState: Equatable {
    @BindableState var isHome: Bool = false
    var offset: Double = -(bounds.width)
    var opacity: Double = 0.0
    var isMenu: Bool = false
    var trainerCalendarState: TrainerCalendarState = TrainerCalendarState()
    var showFilter: Bool = false
    var trainers: [String] = []
    @BindableState var trainerSelector: Int = 0
    var gymDetailState: GymDetailState = GymDetailState()
    var showDetails: Bool = false
    var date: String = ""
    @BindableState var dateSelector: Int = 0
}

enum TrainerHomeAction: Equatable, BindableAction {
    case binding(BindingAction<TrainerHomeState>)
    case onTapMenu
    case onTapLogo
    case trainerCalenadarAction(TrainerCalendarAction)
    case onTapFilter
    case onAppear
    case getTrainerResponse(Result<[String], GetTrainerClient.Failure>)
    case onChangeTrainer(String)
    case gymDetailAction(GymDetailAction)
    case onTapCalendarTile(String)
}

struct TrainerHomeEnvironment {
    var getTrainerClient: GetTrainerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getTrainerClient: GetTrainerClient.live,
        mainQueue: .main
    )
}

let trainerHomeReducer: Reducer = Reducer<TrainerHomeState, TrainerHomeAction, TrainerHomeEnvironment>.combine(
    trainerCalendarReducer.pullback(state: \TrainerHomeState.trainerCalendarState,
                                    action: /TrainerHomeAction.trainerCalenadarAction,
                                    environment: { _ in TrainerCalendarEnvironment(getGymDataClient: .live, mainQueue: .main) }),
    gymDetailReducer.pullback(state: \TrainerHomeState.gymDetailState,
                              action: /TrainerHomeAction.gymDetailAction,
                              environment: { _ in GymDetailEnvironment(getGymDetailsClient: .live, mainQueue: .main) }),
    Reducer { state, action, environment in
        switch action {
        case .binding:
            return .none
        case .onTapMenu:
            state.isMenu = state.isMenu ? false : true
            if state.isMenu {
                state.opacity = 1.0
                state.offset = bounds.width * -0.3
            } else {
                state.opacity = 0.0
                state.offset = -(bounds.width)
            }
            return .none
        case .onTapLogo:
            state.isHome = true
            return .none
        case .trainerCalenadarAction:
            return .none
        case .onTapFilter:
            state.showFilter = state.showFilter ? false : true
            return .none
        case .onAppear:
            return environment.getTrainerClient.fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(TrainerHomeAction.getTrainerResponse)
        case let .getTrainerResponse(.success(response)):
            state.trainers = response
            state.trainerSelector = state.trainers.firstIndex(of: UserDefaults.standard.string(forKey: "userName")!)!
            return .none
        case .getTrainerResponse(.failure):
            return .none
        case let .onChangeTrainer(targetName):
            state.showFilter = false
            return Effect(value: TrainerHomeAction.trainerCalenadarAction(.getGymData(targetName)))
        case .gymDetailAction(.getGymDetails):
            return .none
        case .gymDetailAction:
            return .none
        case let .onTapCalendarTile(date):
            guard date != "" && date != "99" else {
                state.showDetails = false
                return .none
            }
            state.date = date
            state.showDetails.toggle()
            state.dateSelector = state.trainerCalendarState.gymDates.firstIndex(of: date)!
            return .none
        }
    }
)
.binding()
