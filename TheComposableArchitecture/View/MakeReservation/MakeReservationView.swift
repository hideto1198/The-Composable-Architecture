//
//  MakeReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationView: View {
    let viewStore: ViewStore<MakeReservationState,MakeReservationAction>
    var body: some View {
        VStack {
            AppHeaderView(title: "予約画面")
            ScrollView{
                VStack(alignment: .leading) {
                    HStack {
                        Text("メニュー")
                        Spacer()
                        Picker("Tab", selection: self.viewStore.binding(send: MakeReservationAction.onTapPlace)
                        ){
                            Text("パーソナルトレーニング")
                                .tag(MakeReservationState.Tab.personal)
                        }
                    }
                    HStack {
                        Text("場所")
                        Spacer()
                        Picker("Tab", selection: self.viewStore.binding(send: MakeReservationAction.onTapPlace)
                        ){
                            Text("選択してください")
                                .tag(MakeReservationState.Tab.none)
                            Text("板垣店")
                                .tag(MakeReservationState.Tab.itagaki)
                            Text("二の宮店")
                                .tag(MakeReservationState.Tab.ninomiya)
                        }
                    }
                }
            }
            Spacer()
        }
        .onTapGesture {
            debugPrint(self.viewStore.placeSelector)
        }
    }
}

struct MakeReservationView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                             reducer: makeReservationReducer,
                                                       environment: MakeReservationEnvironment())))
    }
}
