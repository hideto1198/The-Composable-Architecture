//
//  StoreDateSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/03.
//

import SwiftUI
import ComposableArchitecture

struct StoreDateSelectView: View {
    let viewStore: ViewStore<StorePersonalChangeState, StorePersonalChangeAction>
    var body: some View {
        HStack {
            Text("日付選択")
            DatePicker("", selection: viewStore.binding(\.$dateSelector), displayedComponents: .date)
                .labelsHidden()
                .onChange(of: viewStore.dateSelector) { _ in
                    viewStore.send(.storePersonalCurrentAction(.getStoreCurrent(viewStore.dateSelector)))
                }
            Spacer()
        }
        .padding(.top)
    }
}

struct StoreDateSelectView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDateSelectView(viewStore: ViewStore(Store(initialState: StorePersonalChangeState(),
                                                       reducer: storePersonalChangeReducer,
                                                       environment: .live)))
    }
}
