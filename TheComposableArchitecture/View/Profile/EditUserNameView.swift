//
//  EditUserNameView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI
import ComposableArchitecture

struct EditUserNameView: View {
    let store: Store<ProfileState, ProfileAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "名前変更")
                HStack {
                    InputProfileTextField(title: "姓", text: viewStore.binding(\.$firstName1))
                        .padding(.leading)
                    InputProfileTextField(title: "名", text: viewStore.binding(\.$lastName1))
                        .padding(.trailing)
                }
                HStack {
                    InputProfileTextField(title: "セイ", text: viewStore.binding(\.$firstName2))
                        .padding(.leading)
                    InputProfileTextField(title: "メイ", text: viewStore.binding(\.$lastName2))
                        .padding(.trailing)
                }
                Spacer()
                Button(
                    action: {
                        viewStore.send(.onSave)
                    }
                ) {
                    ButtonView(text: "保存")
                        .padding(.bottom)
                }
            }
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
        }
    }
}

struct EditUserNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserNameView(store: Store(initialState: ProfileState(),
                                      reducer: profileReducer,
                                      environment: .live))
    }
}
