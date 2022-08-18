//
//  HomeMenuView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import SwiftUI
import ComposableArchitecture

struct HomeMenuView: View {
    let viewStore: ViewStore<HomeState, HomeAction>
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(
                    action: {
                        viewStore.send(.onMenuTap, animation: .easeOut)
                    }
                ){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                        .foregroundColor(.primary)
                }
                .offset(x: bounds.width * 0.3)
                NavigationLink(
                    destination: MakeReservationView(store:
                                                        Store(initialState: MakeReservationState(),
                                                                          reducer: makeReservationReducer,
                                                              environment: .live)
                                                                 
                                                    )
                                    .navigationBarHidden(true),
                    label: {
                    MenuView(title: "予約")
                })
                .offset(x: bounds.width * 0.3)
                Divider()
                NavigationLink(destination: EmptyView(), label: {
                    MenuView(title: "お問い合わせ")
                })
                .offset(x: bounds.width * 0.3)
                Divider()
                NavigationLink(destination: LaunchScreenView(store: Store(initialState: LaunchState(),
                                                                          reducer: launchReducer,
                                                                          environment: LaunchEnvironment(mainQueue: .main, authenticationClient: .live)))
                    .navigationBarHidden(true),
                               label: {
                    MenuView(title: "タイトルへ")
                })
                .offset(x: bounds.width * 0.3)
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 50)
            Spacer()
        }
        .background(Color("background"))
        .edgesIgnoringSafeArea(.vertical)
        .offset(x: bounds.width * -0.3)
    }
}

struct HomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuView(viewStore: ViewStore(
            Store(initialState: HomeState(),
                  reducer: homeReducer,
                  environment: .live)
        ))
    }
}
