//
//  HomeView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/27.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: Store<HomeState, HomeAction>
    var body: some View {
        WithViewStore(self.store.self){ viewStore in
            VStack {
                ReservationView(viewStore: viewStore)
                TicketView(store: self.store.scope(state: \.ticketState, action: HomeAction.ticketAction))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(store: Store(initialState: HomeState(),
                              reducer: homeReducer,
                              environment: .live))
    }
}
