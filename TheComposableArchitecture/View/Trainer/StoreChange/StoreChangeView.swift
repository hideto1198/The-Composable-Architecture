//
//  StoreChangeView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct StoreChangeView: View {
    let store: Store<StoreChangeState, StoreChangeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "店舗変更")
                Picker(selection: viewStore.binding(\.$viewSelector), label: Text("")) {
                    Text("デフォルト")
                        .tag(0)
                    Text("日別/時間帯別")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding([.top, .horizontal])
                
                if viewStore.viewSelector == 0 {
                    StoreDefaultChangeView(store: self.store.scope(state: \.storeDefaultChangeState, action: StoreChangeAction.storeDefaultChangeAction))
                        .onDisappear {
                            viewStore.send(.storeDefaultChangeAction(.onDisappear))
                        }
                } else {
                    StorePersonalChangeView(store: self.store.scope(state: \.storePersonalChangeState, action: StoreChangeAction.storePersonalChangeAction))
                        .onDisappear {
                            viewStore.send(.storePersonalChangeAction(.onDisappear))
                        }
                }
                
                Spacer()
            }
        }
    }
}

struct StoreChangeView_Previews: PreviewProvider {
    static var previews: some View {
        StoreChangeView(store: Store(initialState: StoreChangeState(),
                                     reducer: storeChangeReducer,
                                     environment: .live))
    }
}
