//
//  TrainerTrainerSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerTrainerSelectView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    
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

struct TrainerTrainerSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerTrainerSelectView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                            reducer: trainerMakeReservationReducer,
                                                            environment: .live)))
    }
}
