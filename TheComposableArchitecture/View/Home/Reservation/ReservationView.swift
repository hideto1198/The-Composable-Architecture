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
            VStack {
                ReservationListView(viewStore: self.viewStore)
                HStack {
                    Spacer()
                    Button(
                        action: {
                            self.viewStore.send(.reservationAction(.getReservation), animation: .easeIn)
                        }
                    ){
                        Text("取得")
                    }
                    Spacer()
                    Button(
                        action: {
                            self.viewStore.send(.reservationAction(.reset), animation: .easeIn)
                        }
                    ){
                        Text("リセット")
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
            if self.viewStore.reservationState.isLoading {
                ActivityIndicator()
            }
        }
        .onAppear{
            self.viewStore.send(.reservationAction(.getReservation), animation: .easeIn)
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(viewStore: ViewStore(
            Store(initialState: HomeState(),
                  reducer: homeReducer,
                  environment: .live)
        )
        )
    }
}
