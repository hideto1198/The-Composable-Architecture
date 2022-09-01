//
//  SearchBarView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import SwiftUI
import ComposableArchitecture

struct SearchBarView: View {
    let viewStore: ViewStore<CustomerSearchState, CustomerSearchAction>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 239 / 255,
                            green: 239 / 255,
                            blue: 241 / 255))
                .frame(height: 36)
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading)
                TextField("顧客名", text: viewStore.binding(\.$searchText))
            }
        }
        .padding([.horizontal, .top])
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(viewStore: ViewStore(Store(initialState: CustomerSearchState(),
                                                 reducer: customerSearchReducer,
                                                 environment: .live)))
    }
}
