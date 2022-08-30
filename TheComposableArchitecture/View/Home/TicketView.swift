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
                if viewStore.ticket.counts != 0 || viewStore.ticket.subCounts != 0{
                    Text("現在所持しているプラン")
                        .font(.custom("", size: 15))
                    Divider()
                }
                Group {
                    if viewStore.ticket.counts != 0 {
                        Text("\(viewStore.ticket.name)")
                        Text("<\(viewStore.ticket.maxCounts)回>")
                        HStack {
                            Spacer()
                            Text("残り \(viewStore.ticket.counts) 回")
                        }
                    }
                    if viewStore.ticket.subCounts != 0 {
                        Text("\(viewStore.ticket.subName)")
                        Text("<\(viewStore.ticket.subMaxCounts)回>")
                        HStack {
                            Spacer()
                            Text("残り \(viewStore.ticket.subCounts) 回")
                        }
                    }
                }
                .font(.custom("", size: 13))
            }
            .padding(.horizontal)
            .onAppear {
                viewStore.send(.getTicket, animation: .easeIn)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(store: Store(initialState: TicketState(ticket: TicketEntity(
                                                    name: "トレーニングプラン",
                                                    counts: 10,
                                                    maxCounts: 10,
                                                    subName: "トレーニングプラン",
                                                    subCounts: 20,
                                                    subMaxCounts: 20)),
                                reducer: ticketReducer,
                                environment: TicketEnvironment(ticketClient: .live, mainQueue: .main)
        ))
    }
}
