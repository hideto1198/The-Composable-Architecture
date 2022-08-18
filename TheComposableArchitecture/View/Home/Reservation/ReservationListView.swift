//
//  ReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ReservationListView: View {
    var viewStore: ViewStore<HomeState, HomeAction>
    var body: some View {
        ScrollView(.vertical) {
            ForEach(self.viewStore.reservationState.reservations) { reservation in
                ReservationRowView(reservation: reservation)
                    .onTapGesture {
                        self.viewStore.send(.reservationAction(.onTapGesture(reservation.id)), animation: .easeIn)
                    }
                if reservation.isTap {
                    Button(
                        action: {
                            self.viewStore.send(.reservationAction(.onTapDelete(reservation)))
                            // self.viewStore.send(.ticketAction(.getTicket), animation: .easeIn)
                        }
                    ){
                        CancelButtonView()
                    }
                    .padding(.top)
                }
            }
        }
    }
}

struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView(
            viewStore: ViewStore<HomeState, HomeAction>.init(Store(
                initialState: HomeState(),
                reducer: homeReducer,
                environment: HomeEnvironment(
                    reservationClient: .live,
                    ticketClient: .live,
                    deleteClient: .live,
                    mainQueue: .main)
            ))
        )
    }
}
