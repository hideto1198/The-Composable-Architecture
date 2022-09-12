//
//  CustomerProfileStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/12.
//

import Foundation
import ComposableArchitecture

struct CustomerProfileState: Equatable {
    @BindableState var firstName1: String = ""
    @BindableState var firstName2: String = ""
    @BindableState var lastName1: String = ""
    @BindableState var lastName2: String = ""
    @BindableState var planName: String = ""
    @BindableState var planCounts: Int = 0
    @BindableState var memo: String = ""
    var counts: [String] = [String](repeating: "", count: 41)
    
    init() {
        for i in self.counts.indices {
            self.counts[i] = "\(i)"
        }
    }
}

enum CustomerProfileAction: Equatable, BindableAction {
    case binding(BindingAction<CustomerProfileState>)
    case onAppear(UserEntity)
    case setCustomerProfile
    case setCustomerProfileResponse(Result<Bool, SetCustomerProfileClient.Failure>)
}

struct CustomerProfileEnvironment {
    let setCustomerClient: SetCustomerProfileClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        setCustomerClient: .live,
        mainQueue: .main
    )
}

let customerProfileReducer: Reducer = Reducer<CustomerProfileState, CustomerProfileAction, CustomerProfileEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case let .onAppear(user):
        state.firstName1 = user.firstName1
        state.firstName2 = user.firstName2
        state.lastName1 = user.lastName1
        state.lastName2 = user.lastName2
        state.planName = user.planName
        state.planCounts = user.planCounts
        state.memo = user.memo
        return .none
    case .setCustomerProfile:
        return environment.setCustomerClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(CustomerProfileAction.setCustomerProfileResponse)
    case .setCustomerProfileResponse(_):
        return .none
    }
}
.binding()
