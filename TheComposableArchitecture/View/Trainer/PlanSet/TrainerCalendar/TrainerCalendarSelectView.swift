//
//  TrainerCalendarSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarSelectView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    
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

struct TrainerCalendarSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarSelectView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                             reducer: trainerMakeReservationReducer,
                                                             environment: .live)))
    }
}
