//
//  TrainerTimescheduleView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerTimescheduleView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    var times: [[String]] = [
        ["9:00","9:30","10:00","10:30","11:00","11:30"],
        ["12:00","12:30","13:00","13:30","14:00","14:30"],
        ["15:00","15:30","16:00","16:30","17:00","17:30"],
        ["18:00","18:30","19:00","19:30","20:00","20:30"],
        ["21:00","21:30","22:00","22:30"]
    ]
    
    var body: some View {
        if !viewStore.trainerTimescheduleState.isLoading {
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        ForEach(times.indices, id: \.self) { i in
                            HStack {
                                ForEach(times[i].indices, id: \.self) { n in
                                    Button(
                                        action: {
                                            viewStore.send(.trainerTimescheduleAction(.onTapTime(times[i][n])), animation: .easeInOut)
                                        }
                                    ){
                                        TimescheduleTileView(time: viewStore.trainerTimescheduleState.times[times[i][n]]!)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                HStack {
                    if #available(iOS 15, *) {
                        Picker(selection: viewStore.binding(\.trainerTimescheduleState.$timeFromSelector), label: Text("")) {
                            ForEach(times.flatMap({$0}).indices, id: \.self) { i in
                                Text(times.flatMap({$0})[i])
                                    .tag(i)
                            }
                        }
                        Text("〜")
                        Picker(selection: viewStore.binding(\.trainerTimescheduleState.$timeToSelector), label: Text("")) {
                            ForEach(times.flatMap({$0}).indices, id: \.self) { i in
                                Text(times.flatMap({$0})[i])
                                    .tag(i)
                            }
                        }
                    } else {
                        Picker(selection: viewStore.binding(\.trainerTimescheduleState.$timeFromSelector), label: Text("\(times.flatMap({$0})[viewStore.trainerTimescheduleState.timeFromSelector])")) {
                            ForEach(times.flatMap({$0}).indices, id: \.self) { i in
                                Text(times.flatMap({$0})[i])
                                    .tag(i)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Text("〜")
                        Picker(selection: viewStore.binding(\.trainerTimescheduleState.$timeToSelector), label: Text("\(times.flatMap({$0})[viewStore.trainerTimescheduleState.timeToSelector])")) {
                            ForEach(times.flatMap({$0}).indices, id: \.self) { i in
                                Text(times.flatMap({$0})[i])
                                    .tag(i)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    Button(
                        action: {}
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0.5)
                            Text("選択")
                        }
                        .frame(width: bounds.width * 0.3, height: bounds.height * 0.03)
                    }
                }
                HStack {
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.trainerTimescheduleAction(.allSelect))
                        }
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0.5)
                            Text("全選択")
                        }
                        .frame(width: bounds.width * 0.3, height: bounds.height * 0.03)
                    }
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.trainerTimescheduleAction(.allCancel))
                        }
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0.5)
                            Text("全解除")
                        }
                        .frame(width: bounds.width * 0.3, height: bounds.height * 0.03)
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
        } else {
            HStack {
                Spacer()
                ActivityIndicator()
                Spacer()
            }
        }
    }
}

struct TrainerTimescheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerTimescheduleView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                           reducer: trainerMakeReservationReducer,
                                                           environment: .live)))
    }
}
