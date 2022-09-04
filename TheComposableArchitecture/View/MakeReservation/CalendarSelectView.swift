//
//  CalendarSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI
import ComposableArchitecture

struct CalendarSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    
    var body: some View {
        HStack {
            Text("日付")
            Spacer()
            Button(
                action: {
                    viewStore.send(.onTapDate, animation: .easeInOut)
                }
            ){
                Text("\(viewStore.calendarState.reservationDate)")
            }
        }
    }
}

struct CalendarSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSelectView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                      reducer: makeReservationReducer,
                                                      environment: .live)))
    }
}
