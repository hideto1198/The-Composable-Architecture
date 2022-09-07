//
//  TrainerTrainersView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerTrainersView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    
    init(viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>) {
        self.viewStore = viewStore
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.primary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.primary.opacity(0.2))
    }
    
    var body: some View {
        if !viewStore.trainerState.isLoading {
            TabView(selection: viewStore.binding(\.$trainerTabSelector)) {
                ForEach(viewStore.trainerState.trainers.indices, id: \.self) { i in
                    TrainerTrainerView(viewStore:viewStore, trainer: viewStore.trainerState.trainers[i])
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
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

struct TrainerTrainersView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerTrainersView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                       reducer: trainerMakeReservationReducer,
                                                       environment: .live)))
    }
}
