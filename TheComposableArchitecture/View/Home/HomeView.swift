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
                            viewStore.send(.onMenuTap, animation: .easeOut(duration: 0.5))
                        }
                    HomeMenuView(viewStore: viewStore)
                }
                if viewStore.isLoading {
                    LoadingView()
                }
            }
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if value.startLocation.x <= bounds.width * 0.09 && value.startLocation.x * 1.1 < value.location.x {
                            viewStore.send(.onMenuTap, animation: .easeIn)
                        }
                    }
            )
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
