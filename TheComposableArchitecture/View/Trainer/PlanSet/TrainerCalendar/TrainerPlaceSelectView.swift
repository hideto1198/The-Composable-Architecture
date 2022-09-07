//
//  TrainerPlaceSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerPlaceSelectView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    var body: some View {
        HStack {
            Text("場所")
            Spacer()
            if #available(iOS 15, *) {
                Picker("Tab", selection: viewStore.binding(get: {_ in viewStore.placeSelector}, send:{ TrainerMakeReservationAction.onSelectPlace($0) }).animation(.easeInOut)
                ){
                    Text("選択してください")
                        .tag(0)
                    Text("板垣店")
                        .tag(1)
                    Text("二の宮店")
                        .tag(2)
                }
            } else {
                Picker("Tab", selection: viewStore.binding(get: {_ in viewStore.placeSelector}, send:{ TrainerMakeReservationAction.onSelectPlace($0) }).animation(.easeInOut)
                ){
                    Text("選択してください")
                        .tag(0)
                    Text("板垣店")
                        .tag(1)
                    Text("二の宮店")
                        .tag(2)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct TrainerPlaceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerPlaceSelectView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                          reducer: trainerMakeReservationReducer,
                                                          environment: .live)))
    }
}
