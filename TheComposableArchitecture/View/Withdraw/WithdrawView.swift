//
//  WithdrawView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/23.
//

import SwiftUI
import ComposableArchitecture

struct WithdrawView: View {
    @Environment(\.presentationMode) var presentationMode
    let store: Store<WithdrawState, WithdrawAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    AppHeaderView(title: "退会")
                    Group {
                        Text("注意")
                            .foregroundColor(Color.red)
                        Text("・一度退会すると再登録してもデータの復旧できません")
                        Text("・一度退会操作をすると取り消すことはできません")
                        Spacer()
                            .frame(height: bounds.height * 0.05)
                        Text("退会するには入力欄に「退会する」と入力してください")
                        TextField("", text: viewStore.binding(\.$withdraw_text))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                        Button(
                            action: {
                                viewStore.send(.confirmWithdraw)
                            }
                        ) {
                            ButtonView(text: "退会する")
                        }
                    }
                    .padding(.horizontal)
                }
                if viewStore.isLoading {
                    LoadingView()
                }
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
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
        }
    }
}

struct WithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawView(store: Store(initialState: WithdrawState(),
                                  reducer: withdrawReducer,
                                  environment: .live))
    }
}
