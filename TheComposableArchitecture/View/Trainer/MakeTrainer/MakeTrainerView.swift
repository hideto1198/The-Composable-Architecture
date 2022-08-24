//
//  MakeTrainerView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI
import ComposableArchitecture

struct MakeTrainerView: View {
    let store: Store<MakeTrainerState, MakeTrainerAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    AppHeaderView(title: "トレーナー登録画面")
                    MakeTrainerPasswordInputView(password: viewStore.binding(\.$password))
                        .padding(.top)
                    MakeTrainerPathInputView(text: viewStore.binding(\.$path_text))
                        .padding(.top)
                    StoreSelectorView(viewStore: viewStore)
                        .padding(.top)
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.onTapLogin)
                        }
                    ){
                        ButtonView(text: "ログイン")
                    }
                }
                if viewStore.isLoading {
                    LoadingView()
                }
            }
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct MakeTrainerView_Previews: PreviewProvider {
    static var previews: some View {
        MakeTrainerView(store: Store(initialState: MakeTrainerState(),
                                     reducer: makeTrainerReducer,
                                     environment: .live))
    }
}
