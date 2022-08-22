//
//  TicketReaderView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI
import ComposableArchitecture

struct TicketReaderView: View {
    let store: Store<CodeReadState, CodeReadAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "QR読み取り")
                ZStack {
                    CodeReadView(completion: { result in
                        switch result {
                        case let .success(response):
                            viewStore.send(.onRead(response), animation: .linear(duration: 0.5))
                        case .failure(_):
                            return
                        }
                    })
                    Image("LOGO")
                        .resizable()
                        .frame(width: bounds.width * 0.5, height: bounds.width * 0.5)
                        .position(x: (bounds.width / 2), y: (bounds.height / 2) - (bounds.width * 0.25))
                        .cornerRadius(10)
                        .opacity(viewStore.opacity)
                }
            }
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
        }
    }
}

struct TicketReaderView_Previews: PreviewProvider {
    static var previews: some View {
        TicketReaderView(store: Store(initialState: CodeReadState(),
                                      reducer: codeReadReducer,
                                      environment: .live))
    }
}
