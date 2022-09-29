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
                        viewStore.send(.onTapMenu, animation: .easeOut)
                    }
                ){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                        .foregroundColor(.primary)
                }
                .offset(x: bounds.width * 0.3)
                Group {
                    NavigationLink(destination: ProfileView(store: Store(initialState: ProfileState(),
                                                                         reducer: profileReducer,
                                                                         environment: .live))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "基本情報") })
                    NavigationLink(
                        destination: MakeReservationView(store:
                                                            Store(initialState: MakeReservationState(),
                                                                  reducer: makeReservationReducer,
                                                                  environment: .live))
                        .navigationBarHidden(true),
                        label: { MenuView(title: "予約")})
                    NavigationLink(
                        destination: TicketReaderView(store: Store(initialState: CodeReadState(),
                                                                   reducer: codeReadReducer,
                                                                   environment: .live))
                        .navigationBarHidden(true),
                        label: { MenuView(title: "チケット追加") })
                    NavigationLink(destination: EmptyView(), label: { MenuView(title: "チケット購入履歴") })
                    NavigationLink(destination: EmptyView(), label: { MenuView(title: "予約履歴") })
                    NavigationLink(destination: EmptyView(), label: { MenuView(title: "お問い合わせ") })
                    NavigationLink(destination: LaunchScreenView(store: Store(initialState: LaunchState(),
                                                                              reducer: launchReducer,
                                                                              environment: LaunchEnvironment(mainQueue: .main, authenticationClient: .live)))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "タイトルへ") })
                }
                Spacer()
            }
            .padding(.leading)
            Spacer()
        }
        .background(Color("background").edgesIgnoringSafeArea(.vertical))
        .opacity(viewStore.opacity)
        
    }
}

struct HomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuView(viewStore: ViewStore(Store(initialState: HomeState(),
                                                reducer: homeReducer,
                                                environment: .live)))
    }
}
