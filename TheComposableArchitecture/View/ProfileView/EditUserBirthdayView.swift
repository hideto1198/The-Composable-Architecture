//
//  EditUserBirthdayView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI
import ComposableArchitecture

struct EditUserBirthdayView: View {
    let store: Store<ProfileState, ProfileAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "生年月日変更")
                HStack {
                    Text("現在設定されている生年月日")
                    Spacer()
                    Text("\(UserDefaults.standard.string(forKey: "birthday")!)")
                }
                .padding(.horizontal)
                HStack {
                    Text("新しく設定する生年月日")
                    Spacer()
                    DatePicker(selection: viewStore.binding(\.$date),
                               displayedComponents: .date,
                               label: { Text("") })
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ja_JP"))
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

struct EditUserBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserBirthdayView(store: Store(initialState: ProfileState(),
                                          reducer: profileReducer,
                                          environment: .live))
    }
}
