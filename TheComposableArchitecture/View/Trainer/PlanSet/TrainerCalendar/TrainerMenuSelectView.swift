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
    let menus: [String] = ["パーソナルトレーニング"]
    
    var body: some View {
        HStack {
            Text("メニュー")
            Spacer()
            if #available(iOS 15, *) {
                Picker(selection: viewStore.binding(\.$menuSelector), label: Text("")){
                    Text("パーソナルトレーニング")
                        .tag(0)
                }
            } else {
                Picker(selection: viewStore.binding(\.$menuSelector), label: Text("\(menus[viewStore.menuSelector])")){
                    Text("パーソナルトレーニング")
                        .tag(0)
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.trailing)
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
