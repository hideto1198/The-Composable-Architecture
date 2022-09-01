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
        VStack {
            TabView(selection: viewStore.binding(\.$dateSelector)) {
                ForEach(viewStore.trainerCalendarState.gymDates.indices, id: \.self) { i in
                    TrainerCalendarDetailDayView(viewStore: viewStore,
                                                 date: viewStore.trainerCalendarState.gymDates[i])
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .onChange(of: viewStore.dateSelector) { newValue in
                viewStore.send(.onChangeDate(newValue))
                viewStore.send(.gymDetailAction(.getGymDetails(["year": "\(String(viewStore.trainerCalendarState.year))",
                                                                "month": "\(viewStore.trainerCalendarState.month)",
                                                                "day": viewStore.trainerCalendarState.gymDates[viewStore.dateSelector],
                                                                "target": viewStore.trainers[viewStore.trainerSelector]])))
            }
            Button(
                action: {
                    viewStore.send(.onTapCalendarTile("99"), animation: .easeOut)
                }
            ){
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: bounds.width * 0.07, height: bounds.width * 0.07)
                    .foregroundColor(Color("primary_white"))
            }
            .padding(.bottom)
        }
    }
}

struct TrainerCalendarDetailDaysView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailDaysView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                                 reducer: trainerHomeReducer,
                                                                 environment: .live)))
    }
}
