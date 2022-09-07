//
//  StorePersonalCurrentView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct StorePersonalCurrentView: View {
    let viewStore: ViewStore<StorePersonalChangeState, StorePersonalChangeAction>
    var body: some View {
        VStack {
            HStack {
                Text("現在の設定")
                Spacer()
            }
            List {
                ForEach(viewStore.storePersonalCurrentState.details) { detail in
                    Text("\(detail.time) -> \(detail.store)")
                }
            }
        }
    }
}

struct StorePersonalCurrentView_Previews: PreviewProvider {
    static var previews: some View {
        StorePersonalCurrentView(viewStore: ViewStore(Store(initialState: StorePersonalChangeState(),
                                              reducer: storePersonalChangeReducer,
                                              environment: .live)))
    }
}
