//
//  SetCustomerProfileClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/12.
//

import Foundation
import ComposableArchitecture

struct SetCustomerProfileClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SetCustomerProfileClient {
    static let live = SetCustomerProfileClient(fetch: {
        Effect.task {
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}
