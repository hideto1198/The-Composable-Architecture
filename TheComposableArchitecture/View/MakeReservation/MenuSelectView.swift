//
//  MenuSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import SwiftUI
import ComposableArchitecture

struct MenuSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    var body: some View {
        HStack {
            Text("メニュー")
            Spacer()
            if #available(iOS 15, *) {
                Picker("Tab", selection: viewStore.binding(get: {_ in viewStore.menuSelector} , send: {.onSelectMenu($0)}).animation(.linear)
                ){
                    Text("パーソナルトレーニング")
                        .tag(0)
                }
            } else {
                Picker("Tab", selection: viewStore.binding(get: {_ in viewStore.menuSelector} , send: {.onSelectMenu($0)}).animation(.linear)
                ){
                    Text("パーソナルトレーニング")
                        .tag(0)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct MenuSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSelectView(
            viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                       reducer: makeReservationReducer,
                                       environment: .live))
        )
    }
}
