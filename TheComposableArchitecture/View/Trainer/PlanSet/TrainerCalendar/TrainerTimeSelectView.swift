//
//  TrainerTimeSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerTimeSelectView: View {
    let store: Store<TrainerTimescheduleState, TrainerTimescheduleAction>
    
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

struct TrainerTimeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerTimeSelectView(store: Store(initialState: TrainerTimescheduleState(),
                                                     reducer: trainerTimescheduleReducer,
                                                     environment: .live))
    }
}
