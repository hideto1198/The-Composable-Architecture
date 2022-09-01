//
//  TrainerCalendarDetailDaysView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/31.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarDetailDaysView: View {
    let viewStore: ViewStore<TrainerHomeState, TrainerHomeAction>
    
    var body: some View {
        TabView(selection: viewStore.binding(\.$dateSelector)) {
            ForEach(viewStore.trainerCalendarState.gymDates.indices, id: \.self) { i in
                TrainerCalendarDetailDayView(viewStore: viewStore,
                                             date: viewStore.trainerCalendarState.gymDates[i])
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

struct TrainerCalendarDetailDaysView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailDaysView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                                 reducer: trainerHomeReducer,
                                                                 environment: .live)))
    }
}
