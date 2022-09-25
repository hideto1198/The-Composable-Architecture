//
//  TrainerCalendarView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerCalendarView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    let weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                VStack {
                    HStack {
                        Button(
                            action: {
                                viewStore.send(.calendarAction(.onTapPrevious))
                            }
                        ){
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                        }
                        Text("\(String(viewStore.calendarState.year))年\(viewStore.calendarState.month)月")
                            .padding(.all)
                        Button(
                            action: {
                                viewStore.send(.calendarAction(.onTapNext))
                            }
                        ){
                            Image(systemName: "arrow.right")
                                .foregroundColor(.primary)
                        }
                    }
                    HStack(spacing: 3) {
                        ForEach(weeks, id:\.self) { week in
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("app_color"))
                                Text("\(week)")
                            }
                            .frame(width: bounds.width * 0.13, height: bounds.height * 0.03)
                        }
                    }
                    VStack(spacing: 3) {
                        ForEach(viewStore.calendarState.dates.indices, id:\.self) { i in
                            HStack(spacing: 3) {
                                ForEach(viewStore.calendarState.dates[i].indices, id: \.self) { n in
                                    Button(
                                        action: {
                                            viewStore.send(.calendarAction(.onTapTile(viewStore.calendarState.dates[i][n])), animation: .easeInOut)
                                        }
                                    ){
                                        CalendarTileView(date: viewStore.calendarState.dates[i][n].date,
                                                         state: viewStore.calendarState.dates[i][n].state,
                                                         n: n)
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            viewStore.send(.calendarAction(.onAppear))
        }
    }
}

struct TrainerCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                       reducer: trainerMakeReservationReducer,
                                                       environment: .live)))
    }
}
