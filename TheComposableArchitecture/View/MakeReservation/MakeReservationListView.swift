//
//  MakeReservationListView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/17.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationListView: View {
    let store: Store<MakeReservationState, MakeReservationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    Text("予約一覧")
                        .font(.custom("", size: 16))
                        .padding(.top)
                    List {
                        ForEach(viewStore.reservations) { reservation in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("メニュー　： \(reservation.menuName)")
                                    Text("日時　　　： \(reservation.year)年\(reservation.month)月\(reservation.day)日 \(reservation.timeFrom)〜\(reservation.displayTime)")
                                    Text("トレーナー： \(reservation.trainerName)")
                                    Text("場所　　　： \(reservation.placeName)")
                                }
                                .font(.custom("", size: 15))
                                Spacer()
                            }
                        }
                        .onDelete(perform: { offsets in
                            viewStore.send(.onDelete(offsets))
                        })
                    }
                    Spacer()
                    Button(
                        action:{
                            viewStore.send(.onTapConfirm)
                        }
                    ){
                        ButtonView(text: "確定")
                    }
                    .padding(.vertical)
                }
                if viewStore.isLoading {
                    LoadingView()
                }
            }
            .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
        }
    }
}

struct MakeReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationListView(store: Store(initialState: MakeReservationState(reservations: [MakeReservationEntity(menuName: "パーソナルトレーニング",
                                                                                                                                   placeName: "板垣店",
                                                                                                                                   year: "2022",
                                                                                                                                   month: "8",
                                                                                                                                   day: "19",
                                                                                                                                   trainerName: "テスト　トレーナー",
                                                                                                                                   timeFrom: "19:00",
                                                                                                                                   timeTo: "19:30",
                                                                                                                                   displayTime: "20:00")]),
                                                           reducer: makeReservationReducer,
                                                           environment: .live))
    }
}
