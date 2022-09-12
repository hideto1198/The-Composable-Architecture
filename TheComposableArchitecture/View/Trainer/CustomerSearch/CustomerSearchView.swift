//
//  CustomerSearchView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct CustomerSearchView: View {
    let store: Store<CustomerSearchState, CustomerSearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    AppHeaderView(title: "顧客検索")
                    SearchBarView(viewStore: viewStore)
                    List(viewStore.users.filter {
                        if viewStore.searchText.isEmpty {
                            return true
                        }
                        return "\($0.firstName1)　\($0.lastName1)".contains(viewStore.searchText)
                    }) { user in
                        NavigationLink(destination: CustomerProfileView(store: Store(initialState: CustomerProfileState(),
                                                                                     reducer: customerProfileReducer,
                                                                                     environment: .live),
                                                                        user: user)
                            .navigationBarHidden(true)) {
                            Text("\(user.firstName1)　\(user.lastName1)")
                        }
                    }
                    .listStyle(.plain)
                    Spacer()
                }
                if viewStore.isLoading {
                    ActivityIndicator()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct CustomerSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchView(store: Store(initialState: CustomerSearchState(),
                                        reducer: customerSearchReducer,
                                        environment: .live))
    }
}
