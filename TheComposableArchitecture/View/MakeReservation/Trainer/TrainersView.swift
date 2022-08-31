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
        if !viewStore.trainerState.isLoading {
            TabView(selection: viewStore.binding(\.$trainerTabSelector)) {
                ForEach(viewStore.trainerState.trainers.indices, id: \.self) { i in
                    TrainerView(viewStore:viewStore, trainer: viewStore.trainerState.trainers[i])
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: bounds.height * 0.35)
        }else{
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ActivityIndicator()
                    Spacer()
                }
                Spacer()
            }
            .frame(width: bounds.width * 0.9, height: bounds.height * 0.23)
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
