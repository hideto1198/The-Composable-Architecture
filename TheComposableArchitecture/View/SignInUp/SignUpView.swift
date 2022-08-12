//
//  SignUpView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    let store: Store<SignUpState, SignUpAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: bounds.height * 0.1)
                    Image("LOGO")
                        .resizable()
                        .frame(width: bounds.width * 0.4, height: bounds.width * 0.4)
                    Spacer()
                        .frame(height: bounds.height * 0.05)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("app_color").edgesIgnoringSafeArea(.all))
                if viewStore.isLoading {
                    ActivityIndicator()
                }
                NavigationLink(
                    destination: RegisterView(store: Store(initialState: RegisterState(),
                                                           reducer: registerReducer,
                                                           environment: .live))
                        .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isRegister),
                    label: { Text("") }
                )
            }
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(store: Store(initialState: SignUpState(),
                                reducer: signUpReducer,
                                environment: .live))
    }
}
