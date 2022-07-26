//
//  TimescheduleView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI
import ComposableArchitecture

struct TimescheduleView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    var times: [[String]] = [
        ["9:00","9:30","10:00","10:30","11:00","11:30"],
        ["12:00","12:30","13:00","13:30","14:00","14:30"],
        ["15:00","15:30","16:00","16:30","17:00","17:30"],
        ["18:00","18:30","19:00","19:30","20:00","20:30"],
        ["21:00","21:30","22:00","22:30"]
    ]
    var body: some View {
        if !viewStore.timescheduleState.isLoading {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(times.indices, id: \.self) { i in
                        HStack {
                            ForEach(times[i].indices, id: \.self) { n in
                                Button(
                                    action: {
                                        viewStore.send(.timescheduleAction(.onTapTime(times[i][n])), animation: .easeInOut)
                                    }
                                ){
                                    TimescheduleTileView(time: viewStore.timescheduleState.times[times[i][n]]!)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        } else {
            HStack {
                Spacer()
                ActivityIndicator()
                Spacer()
            }
        }
    }
}

struct TimescheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TimescheduleView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                    reducer: makeReservationReducer,
                                                    environment: .live)))
    }
}
