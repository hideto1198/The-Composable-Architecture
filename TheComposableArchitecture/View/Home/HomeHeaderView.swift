//
//  HomeHeaderView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import SwiftUI
import ComposableArchitecture

struct HomeHeaderView: View {
    let store: Store<HomeState, HomeAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                ZStack {
                    HStack {
                        Button(
                            action: {
                                viewStore.send(.onTapMenu, animation: .easeIn)
                            }
                        ){
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("BONA FIDE")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Image("LOGO")
                            .resizable()
                            .frame(width: bounds.width * 0.076, height: bounds.width * 0.076)
                            .onTapGesture(count: 3,perform: {
                                viewStore.send(.onTapLogo, animation:.easeInOut)
                            })
                    }
                }
                .padding(.all)
                Divider()
            }
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(store:
                        Store(initialState: HomeState(),
                              reducer: homeReducer,
                              environment: .live)
        )
    }
}
