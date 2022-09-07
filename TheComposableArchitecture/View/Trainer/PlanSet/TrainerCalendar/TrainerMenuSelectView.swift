//
//  TrainerMenuSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerMenuSelectView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
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

struct TrainerMenuSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerMenuSelectView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                         reducer: trainerMakeReservationReducer,
                                                         environment: .live)))
    }
}
