//
//  ContentView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        HomeView(store: store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: HomeState(),
                reducer: homeReducer,
                environment: .live
            )
        )
    }
}
