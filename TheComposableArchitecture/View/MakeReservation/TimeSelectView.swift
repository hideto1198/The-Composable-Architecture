//
//  TimeSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI
import ComposableArchitecture

struct TimeSelectView: View {
    let store: Store<TimescheduleState, TimescheduleAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Text("時間")
                Spacer()
                Button(
                    action: {
                        viewStore.send(.onTapReservationTime, animation: .easeInOut)
                    }
                ){
                    Text("\(viewStore.reservationTime)")
                }
            }
        }
    }
}

struct TimeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectView(store: Store(initialState: TimescheduleState(),
                                                  reducer: timescheduleReducer,
                                                  environment: .live))
    }
}
