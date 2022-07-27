//
//  ReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ReservationListView: View {
    var viewStore: ViewStore<ReservationState, ReservationAction>
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(self.viewStore.state.reservations) { reservation in
                ReservationRowView(reservation: reservation)
                    .onTapGesture {
                        self.viewStore.send(.onTapGesture(reservation.id), animation: .easeIn)
                    }
                if reservation.isTap {
                    Button(
                        action: {
                            
                        }
                    ){
                        CancelButtonView()
                    }
                }
            }
        }
    }
}

struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView(
            viewStore: ViewStore<ReservationState, ReservationAction>.init(Store(
                initialState: ReservationState(reservations: [
                    ReservationEntity(
                        date: "2022年7月7日",
                        place: "二の宮店",
                        menu: "パーソナルトレーニング",
                        trainer_name: "テスト　トレーナー",
                        isTap: false
                    )
                ]),
                reducer: reservationReducer,
                environment: ReservationEnvironment(
                    reservationClient: .live,
                    mainQueue: .main)
            ))
        )
    }
}
