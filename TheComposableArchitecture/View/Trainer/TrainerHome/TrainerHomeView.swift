//
//  TrainerHomeView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI
import ComposableArchitecture

struct TrainerHomeView: View {
    let store: Store<TrainerHomeState, TrainerHomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    TrainerHomeHeaderView(store: self.store)
                    TrainerHomeCalendarView(viewStore: viewStore)
                    Spacer()
                }
                if viewStore.showDetails {
                    Color.gray
                        .opacity(0.7)
                        .edgesIgnoringSafeArea(.vertical)
                        .onTapGesture {
                            viewStore.send(.onTapCalendarTile("99"), animation: .easeOut)
                        }
                    // TrainerCalendarDetailDayView(viewStore: viewStore)
                    TrainerCalendarDetailDaysView(viewStore: viewStore)
                }
                if viewStore.isMenu {
                    Color.gray
                        .opacity(0.7)
                        .edgesIgnoringSafeArea(.vertical)
                        .onTapGesture {
                            viewStore.send(.onTapMenu, animation: .easeOut)
                        }
                }
                TrainerHomeMenuView(viewStore: viewStore)
                    .offset(x: viewStore.offset)
                NavigationLink(
                    destination: HomeView(store: Store(initialState: HomeState(),
                                                       reducer: homeReducer,
                                                       environment: .live))
                    .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isHome),
                    label: { Text("") }
                )
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
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
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct TrainerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerHomeView(store: Store(initialState: TrainerHomeState(),
                                     reducer: trainerHomeReducer,
                                     environment: .live))
    }
}
