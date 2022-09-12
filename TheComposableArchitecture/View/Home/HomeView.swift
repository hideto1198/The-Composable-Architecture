//
//  HomeView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/27.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store.self){ viewStore in
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
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
                            viewStore.send(.onTapMenu, animation: .easeOut)
                        }
                }
                HomeMenuView(viewStore: viewStore)
                    .offset(x: viewStore.offset)
                
                if viewStore.isLoading {
                    LoadingView()
                }
                
                NavigationLink(
                    destination: MakeTrainerView(store: Store(initialState: MakeTrainerState(),
                                                              reducer: makeTrainerReducer,
                                                              environment: .live))
                        .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isMakeTrainer),
                    label: { Text("") }
                )
                NavigationLink(
                    destination: TrainerHomeView(store: Store(initialState: TrainerHomeState(),
                                                              reducer: trainerHomeReducer,
                                                              environment: .live))
                    .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isTrainer),
                    label: { Text("") }
                )
            }
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
            .onAppear {
                viewStore.send(.onAppear)
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if value.startLocation.x <= bounds.width * 0.09 && value.startLocation.x * 1.1 < value.location.x  && !viewStore.isMenu {
                            viewStore.send(.onTapMenu, animation: .easeIn)
                        } else if value.startLocation.x * 1.3 > value.location.x && viewStore.isMenu {
                            viewStore.send(.onTapMenu, animation: .easeOut)
                        }
                    }
            )
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    viewStore.send(.reservationAction(.getReservation), animation: .easeIn)
                    viewStore.send(.ticketAction(.getTicket), animation: .easeIn)
                    return
                default:
                    return
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
