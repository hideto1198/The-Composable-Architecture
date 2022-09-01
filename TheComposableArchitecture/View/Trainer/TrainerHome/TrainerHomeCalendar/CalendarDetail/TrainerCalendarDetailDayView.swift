//
//  TrainerCalendarDetailDayView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/30.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarDetailDayView: View {
    let viewStore: ViewStore<TrainerHomeState, TrainerHomeAction>
    let date: String
    
    var body: some View {
        ZStack {
            Color("primary_white")
                .cornerRadius(10)
            VStack {
                Text("\(String(viewStore.trainerCalendarState.year))年\(viewStore.trainerCalendarState.month)月\(date)日")
                    .bold()
                    .padding(.vertical)
                List {
                    ForEach(viewStore.gymDetailState.details) { detail in
                        TrainerCalendarDetailRowView(detail: detail)
                    }
                }
                .listStyle(.plain)
                .padding(.bottom)
                Spacer()
                Button(
                    action: {
                        viewStore.send(.onTapCalendarTile("99"), animation: .easeOut)
                    }
                ){
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.primary)
                }
            }
            if viewStore.gymDetailState.isLoading {
                ActivityIndicator()
            }
        }
        .frame(width: bounds.width * 0.9, height: bounds.height * 0.7)
        .onAppear {
            viewStore.send(.gymDetailAction(.getGymDetails(["year": "\(String(viewStore.trainerCalendarState.year))",
                                                            "month": "\(viewStore.trainerCalendarState.month)",
                                                            "day": date,
                                                            "target": viewStore.trainers[viewStore.trainerSelector]])))
        }
    }
}

struct TrainerCalendarDetailDay_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailDayView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                            reducer: trainerHomeReducer,
                                                                environment: .live)),
                                     date: "1")
    }
}
