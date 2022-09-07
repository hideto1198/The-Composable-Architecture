//
//  TrainerMakeReservationListView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerMakeReservationListView: View {
    let store: Store<TrainerMakeReservationState, TrainerMakeReservationAction>
    
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

struct TrainerMakeReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerMakeReservationListView(store: Store(initialState: TrainerMakeReservationState(),
                                                                  reducer: trainerMakeReservationReducer,
                                                                  environment: .live))
    }
}
