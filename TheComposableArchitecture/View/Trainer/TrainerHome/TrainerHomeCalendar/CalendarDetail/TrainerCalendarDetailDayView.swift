//
//  TrainerCalendarDetailDayView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/30.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarDetailDayView: View {
    @Environment(\.scenePhase) var scenePhase
    let store: Store<TrainerHomeState, TrainerHomeAction>
    let date: String
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color("primary_white")
                    .cornerRadius(10)
                VStack {
                    Text("\(String(viewStore.trainerCalendarState.year))年\(viewStore.trainerCalendarState.month)月\(date)日")
                        .bold()
                        .padding(.vertical)
                    if #available(iOS 15.0, *) {
                        List {
                            ForEach(viewStore.gymDetailState.details) { detail in
                                TrainerCalendarDetailRowView(detail: detail)
                                    .onLongPressGesture {
                                        viewStore.send(.trainerCalenadarAction(.onLongTap(detail)))
                                    }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewStore.send(.gymDetailAction(.getGymDetails(["year": "\(String(viewStore.trainerCalendarState.year))",
                                                                            "month": "\(viewStore.trainerCalendarState.month)",
                                                                            "day": date,
                                                                            "target": viewStore.trainers[viewStore.trainerSelector]])))
                        }
                        .padding(.bottom)
                    }
                }
                if viewStore.gymDetailState.isLoading {
                    ActivityIndicator()
                }
            }
            .frame(width: bounds.width * 0.9, height: bounds.height * 0.75)
            .onAppear {
                viewStore.send(.gymDetailAction(.getGymDetails(["year": "\(String(viewStore.trainerCalendarState.year))",
                                                                "month": "\(viewStore.trainerCalendarState.month)",
                                                                "day": date,
                                                                "target": viewStore.trainers[viewStore.trainerSelector]])))
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    viewStore.send(.gymDetailAction(.getGymDetails(["year": "\(String(viewStore.trainerCalendarState.year))",
                                                                    "month": "\(viewStore.trainerCalendarState.month)",
                                                                    "day": date,
                                                                    "target": viewStore.trainers[viewStore.trainerSelector]])))
                    return
                default:
                    return
                }
            }
        }
    }
}

struct TrainerCalendarDetailDay_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailDayView(store: Store(initialState: TrainerHomeState(),
                                                            reducer: trainerHomeReducer,
                                                                environment: .live),
                                     date: "1")
    }
}
