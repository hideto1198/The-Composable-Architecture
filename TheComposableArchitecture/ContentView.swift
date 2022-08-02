//
//  ContentView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<LaunchState, LaunchAction>
    
    var body: some View {
        LaunchScreenView(store: store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(initialState: LaunchState(),
                         reducer: launchReducer,
                         environment: .init(mainQueue: .main)
        ))
    }
}
