//
//  ProfileView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    let store: Store<ProfileState, ProfileAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AppHeaderView(title: "基本情報")
                ScrollView {
                    NavigationLink(
                        destination: EditUserNameView(store: self.store)
                            .navigationBarHidden(true),
                        label: {
                            ProfileContentView(title: "名前",
                                               value: UserDefaults.standard.string(forKey: "user_name")!)
                        }
                    )
                    Divider()
                    NavigationLink(
                        destination: EditUserNameView(store: self.store)
                            .navigationBarHidden(true),
                        label: {
                            ProfileContentView(title: "カナ",
                                               value: UserDefaults.standard.string(forKey: "user_kana_name")!)
                        }
                    )
                    Divider()
                    NavigationLink(
                        destination: EditUserBirthdayView(store: self.store)
                            .navigationBarHidden(true),
                        label: {
                            ProfileContentView(title: "生年月日",
                                               value: UserDefaults.standard.string(forKey: "birthday")!)
                        }
                    )
                    Divider()
                    NavigationLink(
                        destination: EditUserSexView(store: self.store)
                            .navigationBarHidden(true),
                        label: {
                            ProfileContentView(title: "性別",
                                               value: UserDefaults.standard.string(forKey: "sex")!)
                        }
                    )
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.confirmSignout)
                        }
                    ){
                        ButtonView(text: "サインアウト")
                    }
                }
                Spacer()
            }
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if value.startLocation.x <= bounds.width * 0.09 && value.startLocation.x * 1.1 < value.location.x{
                            withAnimation(){
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
            )
            NavigationLink(
                destination: LaunchScreenView(store: Store(initialState: LaunchState(),
                                                           reducer: launchReducer,
                                                           environment: LaunchEnvironment(mainQueue: .main, authenticationClient: .live)))
                .navigationBarHidden(true),
                isActive: viewStore.binding(\.$isLaunch),
                label: { Text("") }
            )
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(store: Store(initialState: ProfileState(),
                                 reducer: profileReducer,
                                 environment: .live))
    }
}
