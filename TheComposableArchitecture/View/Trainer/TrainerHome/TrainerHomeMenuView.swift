//
//  TrainerHomeMenuView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture


struct TrainerHomeMenuView: View {
    let viewStore: ViewStore<TrainerHomeState, TrainerHomeAction>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(
                    action: {
                        viewStore.send(.onTapMenu, animation: .easeOut)
                    }
                ){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                        .foregroundColor(.primary)
                }
                .offset(x: bounds.width * 0.3)
                Group {
                    NavigationLink(destination: CustomerSearchView(store: Store(initialState: CustomerSearchState(),
                                                                                reducer: customerSearchReducer,
                                                                                environment: .live))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "顧客検索") })
                    NavigationLink(destination: TicketPublishView(store: Store(initialState: TicketPublishState(),
                                                                               reducer: ticketPublishReducer,
                                                                               environment: .live))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "チケット発行") })
                    NavigationLink(destination: SendNotificationView(),
                                   label: { MenuView(title: "通知送信") })
                    NavigationLink(destination: StoreChangeView(store: Store(initialState: StoreChangeState(),
                                                                             reducer: storeChangeReducer,
                                                                             environment: .live))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "店舗変更") })
                    NavigationLink(destination: PlanSetView(store: Store(initialState: TrainerMakeReservationState(),
                                                                         reducer: trainerMakeReservationReducer,
                                                                         environment: .live))
                        .navigationBarHidden(true),
                                   label: { MenuView(title: "予定セット") })
                }
                Spacer()
            }
            .padding(.leading)
            Spacer()
        }
        .background(Color("background").edgesIgnoringSafeArea(.vertical))
        .opacity(viewStore.opacity)
    }
}

struct TrainerHomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerHomeMenuView(viewStore: ViewStore(Store(initialState: TrainerHomeState(),
                                                       reducer: trainerHomeReducer,
                                                       environment: .live)))
    }
}
