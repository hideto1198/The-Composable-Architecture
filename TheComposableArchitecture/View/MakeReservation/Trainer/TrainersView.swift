//
//  TrainersView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/09.
//

import SwiftUI
import ComposableArchitecture

struct TrainersView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(viewStore.trainerState.trainers) { trainer in
                    TrainerView(viewStore:viewStore, trainer: trainer)
                        .padding([.bottom, .trailing])
                }
            }
        }
    }
}

struct TrainersView_Previews: PreviewProvider {
    static var previews: some View {
        TrainersView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                reducer: makeReservationReducer,
                                                environment: .live)))
    }
}
