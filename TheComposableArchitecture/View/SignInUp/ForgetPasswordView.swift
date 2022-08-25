//
//  ForgetPasswordView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct ForgetPasswordView: View {
    let viewStore: ViewStore<SignInState, SignInAction>
    
    var body: some View {
        HStack {
            Button(
                action: {
                    viewStore.send(.onTapRecovery)
                }
            ) {
                Text("パスワードを忘れた方はこちら")
                    .underline()
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding([.horizontal, .top])
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(viewStore: ViewStore(Store(initialState: SignInState(),
                                                        reducer: signInReducer,
                                                        environment: .init(signInClient: .live, mainQueue: .main))))
    }
}
