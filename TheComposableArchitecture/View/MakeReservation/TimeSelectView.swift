//
//  TimeSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI
import ComposableArchitecture

struct TimeSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    
    var body: some View {
        HStack {
            Text("時間")
            Spacer()
            Button(
                action: {
                    viewStore.send(.onTapTime, animation: .easeInOut)
                }
            ){
                Text("\(viewStore.reservationTime == "" ? "選択してください" : "\(viewStore.reservationTime)")")
            }
        }
    }
}

struct TimeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                  reducer: makeReservationReducer,
                                                  environment: .live)))
    }
}
