//
//  ContentView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        WithViewStore(self.store.stateless) { viewStore in
            ReservationView(
                store: self.store.scope(
                    state: \.reservation,
                    action: RootAction.reservation
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: RootState(),
                reducer: rootReducer,
                environment: .live
            )
        )
    }
}
