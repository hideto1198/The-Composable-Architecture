//
//  SignUpWithEmailView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/15.
//

import SwiftUI
import ComposableArchitecture

struct SignUpWithEmailView: View {
    let viewStore: ViewStore<SignUpState, SignUpAction>
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(
                    action: {
                        viewStore.send(.onTapClose, animation: .linear)
                    }
                ) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                        .foregroundColor(.primary)
                }
            }
            .padding(.trailing)
            MailInputview(email: viewStore.binding(\.$email))
                .padding(.bottom)
            PasswordInputView(password: viewStore.binding(\.$password))
                .padding(.bottom)
            PasswordInputView(password: viewStore.binding(\.$confirmPassword), title: "パスワード(確認用)")
            Spacer()
            Button(
                action: {
                    viewStore.send(.onTapSendMail)
                }
            ){
                ButtonView(text: "確認メール送信")
            }
            .padding(.bottom)
            Button(
                action: {
                    viewStore.send(.onTapSignUp)
                }
            ){
                ButtonView(text: "サインアップ")
            }
            .padding(.bottom)
        }
    }
}

struct SignUpWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpWithEmailView(viewStore: ViewStore(Store(initialState: SignUpState(), reducer: signUpReducer, environment: .live)))
    }
}
