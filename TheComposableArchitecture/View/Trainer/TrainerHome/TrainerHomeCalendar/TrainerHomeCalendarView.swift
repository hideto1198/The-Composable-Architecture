//
//  TrainerHomeCalendarView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import SwiftUI
import ComposableArchitecture

struct TrainerHomeCalendarView: View {
    let viewStore: ViewStore<TrainerHomeState, TrainerHomeAction>
    let weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        TrainerCalendarHeaderView(viewStore: viewStore)
                        HStack {
                            Button(action: {
                                viewStore.send(.onTapFilter, animation: .easeInOut)
                            }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .resizable()
                                    .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            if !viewStore.trainers.isEmpty && viewStore.trainers[viewStore.trainerSelector] != UserDefaults.standard.string(forKey: "userName")! {
                                Text("\(viewStore.trainers[viewStore.trainerSelector])")
                                    .font(.custom("", size: 12))
                                    .padding(.trailing)
                            }
                        }
                        .padding(.leading)
                    }
                    if viewStore.showFilter {
                        HStack {
                            Picker(selection: viewStore.binding(\.$trainerSelector), label: Text("")) {
                                ForEach(viewStore.trainers.indices, id: \.self) { i in
                                    Text("\(viewStore.trainers[i])")
                                        .tag(i)
                                }
                                .onChange(of: viewStore.trainerSelector) { newTarget in
                                    viewStore.send(.onChangeTrainer(viewStore.trainers[newTarget]))
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    HStack(spacing: 3) {
                        ForEach(weeks, id: \.self) { week in
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("app_color"))
                                Text(week)
                            }
                            .frame(width: bounds.width * 0.13, height: bounds.height * 0.03)
                        }
                    }
                    VStack(spacing: 3) {
                        ForEach(viewStore.trainerCalendarState.dates.indices, id: \.self) { i in
                            HStack(spacing: 3) {
                                ForEach(viewStore.trainerCalendarState.dates[i].indices, id: \.self) { n in
                                    Button(action: {
                                        viewStore.send(.onTapCalendarTile(viewStore.trainerCalendarState.dates[i][n].date), animation: .easeIn)
                                    }) {
                                        TrainerHomeCalendarTileView(date: viewStore.trainerCalendarState.dates[i][n] ,n: n)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
        .onAppear {
            viewStore.send(.onAppear)
            viewStore.send(.trainerCalenadarAction(.onAppear))
        }
        .onDisappear {
            viewStore.send(.trainerCalenadarAction(.onDisappear))
        }
    }
}

struct TrainerHomeCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerHomeCalendarView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                           reducer: trainerHomeReducer,
                                                           environment: .live)))
    }
}
