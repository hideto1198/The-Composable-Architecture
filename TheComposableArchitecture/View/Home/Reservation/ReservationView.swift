//
//  TestView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ReservationView: View {
    let viewStore: ViewStore<HomeState, HomeAction>
    var body: some View {
        ZStack {
            ReservationListView(viewStore: self.viewStore)
            .padding(.bottom)
            if self.viewStore.reservationState.isLoading {
                ActivityIndicator()
            }
        }
        .onAppear {
            self.viewStore.send(.reservationAction(.getReservation), animation: .easeIn)
        }
        .onDisappear {
            self.viewStore.send(.reservationAction(.onDisappear))
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(viewStore: ViewStore(Store(initialState: HomeState(),
                                                   reducer: homeReducer,
                                                   environment: .live)))
    }
}
