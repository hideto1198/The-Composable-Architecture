//
//  PlaceSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import SwiftUI
import ComposableArchitecture

struct PlaceSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    var body: some View {
        HStack {
            Text("場所")
            Spacer()
            Picker("Tab", selection: viewStore.binding(get: {_ in viewStore.placeSelector}, send:{ MakeReservationAction.onSelectPlace($0) }).animation(.easeInOut)
            ){
                Text("選択してください")
                    .tag(0)
                Text("板垣店")
                    .tag(1)
                Text("二の宮店")
                    .tag(2)
            }
        }
    }
}

struct PlaceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSelectView(viewStore: ViewStore(Store(initialState: MakeReservationState(), reducer: makeReservationReducer, environment: MakeReservationEnvironment())))
    }
}
