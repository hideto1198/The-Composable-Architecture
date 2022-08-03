//
//  TicketView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/27.
//

import SwiftUI
import ComposableArchitecture

struct TicketView: View {
    let store: Store<TicketState, TicketAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading) {
                if viewStore.ticket.counts != 0 || viewStore.ticket.sub_counts != 0{
                    Text("現在所持しているプラン")
                        .font(.custom("", size: 15))
                    Divider()
                }
                Group {
                    if viewStore.ticket.counts != 0 {
                        Text("\(viewStore.ticket.name)")
                        Text("<\(viewStore.ticket.max_counts)回>")
                        HStack {
                            Spacer()
                            Text("残り \(viewStore.ticket.counts) 回")
                        }
                    }
                    if viewStore.ticket.sub_counts != 0 {
                        Text("\(viewStore.ticket.sub_name)")
                        Text("<\(viewStore.ticket.sub_max_counts)回>")
                        HStack {
                            Spacer()
                            Text("残り \(viewStore.ticket.sub_counts) 回")
                        }
                    }
                }
                .font(.custom("", size: 13))
            }
            .padding(.horizontal)
            .onAppear{
                viewStore.send(.getTicket, animation: .easeIn)
            }
        }
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(store: Store(
            initialState: TicketState(ticket: TicketEntity(
                name: "トレーニングプラン",
                counts: 10,
                max_counts: 10,
                sub_name: "トレーニングプラン",
                sub_counts: 20,
                sub_max_counts: 20
            )),
            reducer: ticketReducer,
            environment: TicketEnvironment(ticketClient: .live, mainQueue: .main)
        ))
    }
}
