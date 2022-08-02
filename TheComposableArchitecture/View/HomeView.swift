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
            ZStack {
                VStack {
                    HomeHeaderView(store: self.store)
                    ReservationView(viewStore: viewStore)
                    TicketView(store: self.store.scope(state: \.ticketState, action: HomeAction.ticketAction))
                }
                if viewStore.isMenu {
                    Color.gray
                        .opacity(0.7)
                        .edgesIgnoringSafeArea(.vertical)
                        .onTapGesture {
                            viewStore.send(.onMenuTap, animation: .easeOut)
                        }
                    HomeMenuView()
                        .offset(x: bounds.width * -0.3)
                }
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
