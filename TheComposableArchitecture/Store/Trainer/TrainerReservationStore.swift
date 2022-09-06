//
//  TrainerReservationStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/06.
//

import Foundation
import ComposableArchitecture

struct TrainerReservationState: Equatable {
    var details: [GymDetailEntity] = []
    var isLoading: Bool = false
    var currentDate: String = ""
}

enum TrainerReservationAction: Equatable {
    case getGymDetails
    case getGymDetailsResponse(Result<[String: [GymDetailEntity]], GetGymDetailsClient.Failure>)
    case onDisappear
}

struct TrainerReservationEnvironment {
    var getGymDetailsClient: GetGymDetailsClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getGymDetailsClient: GetGymDetailsClient.live,
        mainQueue: .main
    )
}

let trainerReservationReducer: Reducer = Reducer<TrainerReservationState, TrainerReservationAction, TrainerReservationEnvironment> { state, action, environment in
    enum TrainerReservationId {}
    switch action {
    case .getGymDetails:
        state.isLoading = true
        var today: Date = Date()
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        today = dateFormatter.date(from: dateFormatter.string(from: today))!
        let year: Int = Calendar.current.component(.year, from: today)
        let month: Int = Calendar.current.component(.month, from: today)
        let date: Int = Calendar.current.component(.day, from: today)
        let request: [String: String] = ["year": "\(year)",
                                         "month": "\(month)",
                                         "day": "\(date)",
                                         "target": UserDefaults.standard.string(forKey: "userName")!]
        return environment.getGymDetailsClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(TrainerReservationAction.getGymDetailsResponse)
            .cancellable(id: TrainerReservationId.self)
    case let .getGymDetailsResponse(.success(response)):
        state.details = response.values.first!
        state.isLoading = false
        return .none
    case .getGymDetailsResponse(.failure):
        state.isLoading = false
        return .none
    case .onDisappear:
        return .cancel(id: TrainerReservationId.self)
    }
}
