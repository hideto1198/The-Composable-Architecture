//
//  TicketPublishView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct TicketPublishView: View {
    let store: Store<TicketPublishState, TicketPublishAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "チケット発行")
                HStack {
                    Text("プラン名")
                    Spacer()
                    Text("トレーニングプラン")
                }
                .padding([.horizontal, .top])
                CountSelectView(viewStore: viewStore)
                Spacer()
                Button(
                    action: {
                        viewStore.send(.onTapPublish)
                    }
                ) {
                    ButtonView(text: "発行")
                }
                .padding(.bottom)
            }
            .sheet(isPresented: viewStore.binding(\.$showQrCode)) {
                Image(uiImage: UIImage.makeQrCode(text: viewStore.qrData)!)
            }
        }
    }
}

struct TicketPublishView_Previews: PreviewProvider {
    static var previews: some View {
        TicketPublishView(store: Store(initialState: TicketPublishState(),
                                       reducer: ticketPublishReducer,
                                       environment: .live))
    }
}
