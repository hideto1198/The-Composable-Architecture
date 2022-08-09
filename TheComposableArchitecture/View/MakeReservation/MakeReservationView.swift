//
//  MakeReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationView: View {
    let store: Store<MakeReservationState,MakeReservationAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "予約画面")
                ScrollView{
                    VStack(alignment: .leading) {
                        Group {
                            MenuSelectView(viewStore: viewStore)
                            PlaceSelectView(viewStore: viewStore)
                        }
                        .padding(.leading)
                        if viewStore.showReservationDate {
                            HStack {
                                Text("日付")
                                Spacer()
                                Button(
                                    action: {
                                        viewStore.send(.onTapDate, animation: .easeInOut)
                                    }
                                ){
                                    Text("\(viewStore.reservation_date)")
                                }
                            }
                            .padding([.horizontal, .top])
                        }
                        if viewStore.showCalendar {
                            CalendarView(viewStore: viewStore)
                        }
                        if viewStore.showTrainerSelector {
                            TrainerSelectView(viewStore: viewStore)
                                .padding([.horizontal, .top])
                            if viewStore.showTrainer {
                                if !viewStore.trainerState.isLoading {
                                    TrainersView(viewStore: viewStore)
                                        .padding(.horizontal)
                                } else {
                                    ActivityIndicator()
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct MakeReservationView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationView(store: Store(initialState: MakeReservationState(),
                                             reducer: makeReservationReducer,
                                         environment: .live))
    }
}
