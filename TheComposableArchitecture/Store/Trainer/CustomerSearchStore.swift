//
//  CustomerSearchStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import Foundation
import ComposableArchitecture

struct UserEntity: Equatable, Identifiable {
    var id: String {
        return userId
    }
    var userId: String = ""
    var firstName1: String = ""
    var firstName2: String = ""
    var lastName1: String = ""
    var lastName2: String = ""
    var birthday: String = ""
    var sex: String = ""
    var memo: String = ""
    var planName: String = ""
    var planCounts: Int = 0
    var planMaxCounts: Int = 0
}

struct CustomerSearchState: Equatable {
    @BindableState var searchText: String = ""
    var isLoading: Bool = false
    var users: [UserEntity] = []
}

enum CustomerSearchAction: Equatable, BindableAction {
    case binding(BindingAction<CustomerSearchState>)
    case onAppear
    case getCustomerResponse(Result<[UserEntity], GetCustomerClient.Failure>)
}

struct CustomerSearchEnvironment {
    var getCustomerClient: GetCustomerClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        getCustomerClient: GetCustomerClient.live,
        mainQueue: .main
    )
}

let customerSearchReducer: Reducer = Reducer<CustomerSearchState, CustomerSearchAction, CustomerSearchEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onAppear:
        state.isLoading = true
        return environment.getCustomerClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(CustomerSearchAction.getCustomerResponse)
    case let .getCustomerResponse(.success(response)):
        state.isLoading = false
        state.users = response
        return .none
    case .getCustomerResponse(.failure):
        state.isLoading = false
        return .none
    }
}
.binding()
