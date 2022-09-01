//
//  StoreSelectorView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI
import ComposableArchitecture

struct StoreSelectorView: View {
    let viewStore: ViewStore<MakeTrainerState, MakeTrainerAction>
    var body: some View {
        HStack {
            Text("店舗選択")
            Picker(selection: viewStore.binding(\.$storeSelector), label: Text("")) {
                Text("板垣店")
                    .tag(0)
                Text("二の宮店")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
    }
}

struct StoreSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        StoreSelectorView(viewStore: ViewStore(Store(initialState: MakeTrainerState(),
                                                     reducer: makeTrainerReducer,
                                                     environment: .live)))
    }
}
