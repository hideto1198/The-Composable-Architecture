//
//  TrainerSelectorView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/09.
//

import SwiftUI
import ComposableArchitecture

struct TrainerSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    
    var body: some View {
        HStack {
            Text("トレーナー")
            Spacer()
            Button(
                action: {
                    viewStore.send(.onTapTrainer, animation: .easeInOut)
                }
            ){
                Text("\(viewStore.trainer)")
            }
        }
    }
}

struct TrainerSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerSelectView(viewStore: ViewStore(Store(initialState: MakeReservationState(), reducer: makeReservationReducer, environment: .live)))
    }
}
