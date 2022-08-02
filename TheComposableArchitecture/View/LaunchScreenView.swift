//
//  LaunchScreenView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/02.
//

import SwiftUI
import ComposableArchitecture

struct LaunchScreenView: View {
    let store: Store<LaunchState, LaunchAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                LaunchDesignView(viewStore: viewStore)
                NavigationLink(destination: HomeView(store: Store(
                    initialState: HomeState(),
                    reducer: homeReducer,
                    environment: .live
                )), isActive: viewStore.binding(get: \.isLaunch, send: LaunchAction.onNavigate)){
                    EmptyView()
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView(
            store: Store(initialState: LaunchState(),
                         reducer: launchReducer,
                         environment: .init(mainQueue: .main)
        ))
    }
}
