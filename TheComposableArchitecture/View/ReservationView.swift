//
//  TestView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ReservationView: View {
    let store: Store<ReservationState, ReservationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    ReservationListView(viewStore: viewStore)
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                viewStore.send(.getReservation, animation: .easeIn)
                            }
                        ){
                            Text("取得")
                        }
                        Spacer()
                        Button(
                            action: {
                                viewStore.send(.reset, animation: .easeIn)
                            }
                        ){
                            Text("リセット")
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                }
                if viewStore.isLoading {
                    ActivityIndicator()
                }
            }
            .onAppear{
                viewStore.send(.getReservation, animation: .easeIn)
            }
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(store: Store(
            initialState: ReservationState(
                reservations: [
                    ReservationEntity(
                        date: "2022年7月7日",
                        place: "二の宮店",
                        menu: "パーソナルトレーニング",
                        trainer_name: "テスト　トレーナー",
                        isTap: false
                    )
                ]
            ),
            reducer: reservationReducer,
            environment: ReservationEnvironment(
                reservationClient: .live,
                mainQueue: .main)
        )
        )
    }
}
