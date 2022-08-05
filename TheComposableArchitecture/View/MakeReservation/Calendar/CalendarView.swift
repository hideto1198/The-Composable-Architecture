//
//  CalendarView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import SwiftUI
import ComposableArchitecture

struct CalendarView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    let weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("日付を選択してください")
                .padding(.leading)
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
                                ForEach(viewStore.calendarState.dates[i], id: \.self) { date in
                                    Button(
                                        action: {}
                                    ){
                                        CalendarTileView(date: date.date,
                                                         state: date.state)
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                reducer: makeReservationReducer,
                                                environment: MakeReservationEnvironment())))
        }
}
