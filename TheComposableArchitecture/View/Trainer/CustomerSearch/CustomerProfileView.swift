//
//  CustomerProfileView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/12.
//

import SwiftUI
import ComposableArchitecture

struct CustomerProfileView: View {
    let store: Store<CustomerProfileState, CustomerProfileAction>
    let user: UserEntity
    /*
    init(store: Store<CustomerProfileState, CustomerProfileAction>, user: UserEntity) {
        self.store = store
        self.user = user
    }
    */
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "顧客詳細")
                if #available(iOS 16.0, *) {
                    Form {
                        Section {
                            Text("\(user.userId)")
                            Text("\(user.firstName1)　\(user.lastName1)")
                            Text("\(user.firstName2)　\(user.lastName2)")
                            Text("\(user.birthday)")
                            Text("\(user.sex)")
                        } header: {
                            Text("基本情報")
                        }
                        .foregroundColor(.gray)
                        Section {
                            TextField("", text: viewStore.binding(\.$planName))
                            Picker(selection: viewStore.binding(\.$planCounts), label: Text("回数")) {
                                ForEach(viewStore.counts.indices, id: \.self) { i in
                                    Text("\(viewStore.counts[i])")
                                        .tag(i)
                                }
                            }
                        } header: {
                            Text("プラン情報")
                        }
                        Section {
                            TextField("", text: viewStore.binding(\.$memo))
                        } header: {
                            Text("メモ")
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    Form {
                        Section {
                            Text("\(user.userId)")
                            Text("\(user.firstName1)　\(user.lastName1)")
                            Text("\(user.firstName2)　\(user.lastName2)")
                            Text("\(user.birthday)")
                            Text("\(user.sex)")
                        } header: {
                            Text("基本情報")
                        }
                        .foregroundColor(.gray)
                        Section {
                            TextField("", text: viewStore.binding(\.$planName))
                            Picker(selection: viewStore.binding(\.$planCounts), label: Text("回数")) {
                                ForEach(viewStore.counts.indices, id: \.self) { i in
                                    Text("\(viewStore.counts[i])")
                                        .tag(i)
                                }
                            }
                        } header: {
                            Text("プラン情報")
                        }
                        Section {
                            TextField("", text: viewStore.binding(\.$memo))
                        } header: {
                            Text("メモ")
                        }
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onAppear {
                viewStore.send(.onAppear(user))
            }
        }
    }
}

struct CustomerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerProfileView(store: Store(initialState: CustomerProfileState(),
                                        reducer: customerProfileReducer,
                                        environment: .live),
                            user: UserEntity(userId: "ZohNUTnG3idXvvSJXCUyVVekuzz2",
                                             firstName1: "東",
                                             firstName2: "ヒガシ",
                                             lastName1: "秀斗",
                                             lastName2: "ヒデト",
                                             birthday: "1999/09/08",
                                             sex: "男",
                                             memo: "",
                                             planName: "トレーニングプラン",
                                             planCounts: 10,
                                             planMaxCounts: 10))
    }
}
