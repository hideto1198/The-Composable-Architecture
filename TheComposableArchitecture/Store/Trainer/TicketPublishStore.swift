//
//  TicketPublishStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import Foundation
import ComposableArchitecture

struct TicketPublishState: Equatable {
    @BindableState var countSelector: Int = 0
    @BindableState var showQrCode: Bool = false
    var counts: [String] = [String](repeating: "", count: 41)
    var qrData: String = ""

    init() {
        for i in self.counts.indices {
            self.counts[i] = "\(i + 1)"
        }
    }
}

enum TicketPublishAction: Equatable, BindableAction {
    case binding(BindingAction<TicketPublishState>)
    case onTapPublish
}

struct TicketPublishEnvironment {
    
    static let live = Self()
}

let ticketPublishReducer: Reducer = Reducer<TicketPublishState, TicketPublishAction, TicketPublishEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onTapPublish:
        state.qrData = "トレーニングプラン,\(state.counts[state.countSelector]),\(state.counts[state.countSelector]),BONAFIDE"
        state.showQrCode = true
        return .none
    }
}
    .binding()
