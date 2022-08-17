//
//  MakeReservationListView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/17.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationListView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    var body: some View {
        VStack {
            Text("予約一覧")
                .font(.custom("", size: 16))
                .padding(.top)
            List {
                ForEach(viewStore.reservations) { reservation in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("日時　　　：\(reservation.year)年\(reservation.month)月\(reservation.day)日 \(reservation.time_from)〜\(reservation.display_time)")
                                .minimumScaleFactor(0.5)
                            Text("場所　　　： \(reservation.place_name)")
                            Text("トレーナー： \(reservation.menu_name)")
                        }
                        Spacer()
                    }
                }
                .onDelete(perform: { offsets in
                    viewStore.send(.onDelete(offsets))
                })
            }
            Spacer()
            Button(
                action:{}
            ){
                ButtonView(text: "確定")
            }
        }
    }
}

struct MakeReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationListView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                           reducer: makeReservationReducer,
                                                           environment: .live)))
    }
}
