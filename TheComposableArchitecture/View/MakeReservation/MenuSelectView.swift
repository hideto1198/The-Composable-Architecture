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
    let menus: [String] = ["パーソナルトレーニング"]
    
    var body: some View {
        HStack {
            Text("メニュー")
            Spacer()
            if #available(iOS 15, *) {
                Picker(selection: viewStore.binding(\.$menuSelector), label: Text("")){
                    ForEach(menus.indices, id: \.self) { i in
                        Text("\(menus[i])")
                            .tag(i)
                    }
                }
            } else {
                Picker(selection: viewStore.binding(\.$menuSelector), label: Text("\(menus[viewStore.menuSelector])")){
                    ForEach(menus.indices, id: \.self) { i in
                        Text("\(menus[i])")
                            .tag(i)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.trailing)
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
