//
//  EditUserSexView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI
import ComposableArchitecture

struct EditUserSexView: View {
    let store: Store<ProfileState, ProfileAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "性別変更")
                HStack {
                    Text("現在設定されている性別")
                    Spacer()
                    Text("\(UserDefaults.standard.string(forKey: "sex")!)")
                }
                .padding(.horizontal)
                HStack {
                    Text("新しく設定する性別")
                    Spacer()
                    Picker(selection: viewStore.binding(\.$sexSelector), label: Text("")){
                        Text("-")
                            .tag(0)
                        Text("男性")
                            .tag(1)
                        Text("女性")
                            .tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
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

struct EditUserSexView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserSexView(store: Store(initialState: ProfileState(),
                                     reducer: profileReducer,
                                     environment: .live))
    }
}
