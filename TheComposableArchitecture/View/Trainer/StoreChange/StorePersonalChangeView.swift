//
//  StorePersonalChangeView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/02.
//

import SwiftUI
import ComposableArchitecture

struct StorePersonalChangeView: View {
    let store: Store<StorePersonalChangeState, StorePersonalChangeAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    StoreDateSelectView(viewStore: viewStore)
                    StoreTimeSelectView(viewStore: viewStore)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("二の宮")
                            List {
                                ForEach(viewStore.ninomiyaTrainers.indices, id: \.self) { i in
                                    Text("\(viewStore.ninomiyaTrainers[i].trainerName)")
                                        .listRowBackground(viewStore.trainerSelector != nil ? viewStore.trainerSelector!.trainerName == viewStore.ninomiyaTrainers[i].trainerName ? Color.blue.opacity(0.4) : Color("primary_white") : Color("primary_white"))
                                        .onTapGesture {
                                            viewStore.send(.onTapTrainer(viewStore.ninomiyaTrainers[i]))
                                        }
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("板垣店")
                            List {
                                ForEach(viewStore.itagakiTrainers.indices, id: \.self) { i in
                                    Text("\(viewStore.itagakiTrainers[i].trainerName)")
                                        .listRowBackground(viewStore.trainerSelector != nil ? viewStore.trainerSelector!.trainerName == viewStore.itagakiTrainers[i].trainerName ? Color.blue.opacity(0.4) : Color("primary_white") : Color("primary_white"))
                                        .onTapGesture {
                                            viewStore.send(.onTapTrainer(viewStore.itagakiTrainers[i]))
                                        }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    StorePersonalCurrentView(viewStore: viewStore)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                viewStore.send(.onTapLeft)
                            }
                        ) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Button(
                            action: {
                                viewStore.send(.onTapRight)
                            }
                        ) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    Button(
                        action: {
                            viewStore.send(.onSave)
                        }
                    ) {
                        ButtonView(text: "保存")
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .onAppear {
                    viewStore.send(.getTrainerStore)
                    viewStore.send(.storePersonalCurrentAction(.getStoreCurrent(nil)))
                }
                .onDisappear {
                    viewStore.send(.onDisappear)
                    viewStore.send(.storePersonalCurrentAction(.onDisappear))
                }
                if viewStore.isLoading {
                    ActivityIndicator()
                }
            }
        }
    }
}

struct StorePersonalChangeView_Previews: PreviewProvider {
    static var previews: some View {
        StorePersonalChangeView(store: Store(initialState: StorePersonalChangeState(),
                                             reducer: storePersonalChangeReducer,
                                             environment: .live))
    }
}
