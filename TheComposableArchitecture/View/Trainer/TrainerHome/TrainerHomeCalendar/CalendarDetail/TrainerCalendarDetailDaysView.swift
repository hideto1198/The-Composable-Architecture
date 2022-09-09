//
//  TrainerCalendarDetailDaysView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/31.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarDetailDaysView: View {
    let store: Store<TrainerHomeState, TrainerHomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                TabView(selection: viewStore.binding(\.$dateSelector)) {
                    ForEach(viewStore.trainerCalendarState.gymDates.indices, id: \.self) { i in
                        TrainerCalendarDetailDayView(store: self.store,
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
            .alert(self.store.scope(state: \.alert),
                   dismiss: .onDismiss)
        }
    }
}

struct TrainerCalendarDetailDaysView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailDaysView(store: Store(initialState: TrainerHomeState(),
                                                                 reducer: trainerHomeReducer,
                                                                 environment: .live))
    }
}
