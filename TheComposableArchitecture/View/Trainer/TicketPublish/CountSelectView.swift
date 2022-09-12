//
//  CountSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import SwiftUI
import ComposableArchitecture

struct CountSelectView: View {
    let viewStore: ViewStore<TicketPublishState, TicketPublishAction>
    var body: some View {
        HStack {
            Text("回数選択")
            Spacer()
            Group {
                if #available(iOS 15, *) {
                    Picker(selection: viewStore.binding(\.$countSelector), label: Text("")) {
                        ForEach(viewStore.counts.indices, id: \.self) { i in
                            Text("\(viewStore.counts[i])")
                                .tag(i)
                        }
                    }
                    .labelsHidden()
                } else {
                    Picker(selection: viewStore.binding(\.$countSelector), label: Text("\(viewStore.counts[viewStore.countSelector])")) {
                        ForEach(viewStore.counts.indices, id: \.self) { i in
                            Text("\(viewStore.counts[i])")
                                .tag(i)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .padding([.horizontal, .top])
    }
}

struct CountSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CountSelectView(viewStore: ViewStore(Store(initialState: TicketPublishState(),
                                                   reducer: ticketPublishReducer,
                                                   environment: .live)))
    }
}
