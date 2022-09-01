//
//  TrainerCalendarHeaderView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarHeaderView: View {
    let viewStore: ViewStore<TrainerHomeState, TrainerHomeAction>
    
    var body: some View {
        HStack {
            Button(action: {
                viewStore.send(.trainerCalenadarAction(.onTapPrevious(viewStore.trainers[viewStore.trainerSelector])))
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primary)
            }
            Text("\(String(viewStore.trainerCalendarState.year))年\(viewStore.trainerCalendarState.month)月")
                .padding(.all)
            Button(action: {
                viewStore.send(.trainerCalenadarAction(.onTapNext(viewStore.trainers[viewStore.trainerSelector])))
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct TrainerCalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarHeaderView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                             reducer: trainerHomeReducer,
                                                             environment: .live)))
    }
}
