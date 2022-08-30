//
//  SignInView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

struct SignInView: View {
    let store: Store<SignInState, SignInAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    Image("LOGO")
                        .resizable()
                        .frame(width: bounds.width * 0.4, height: bounds.width * 0.4)
                    MailInputView(email: viewStore.binding(\.$email))
                        .padding(.bottom)
                    PasswordInputView(password: viewStore.binding(get: \.password, send: SignInAction.onTextChanged))
                    ForgetPasswordView(viewStore: viewStore)
                    Button(
                        action: {
                            viewStore.send(.onTapSignIn)
                        }
                    ){
                        ButtonView(text: "サインイン")
                    }
                    Spacer()
                    SignInUpWithAppleButton(buttonType: .signIn,
                                            completion: { result in
                                                switch result {
                                                case .success(_):
                                                    viewStore.send(.onTapWithApple(true))
                                                    return
                                                case .failure(_):
                                                    viewStore.send(.onTapWithApple(false))
                                                    return
                                                }
                                            })
                        .frame(width: bounds.width * 0.8, height: bounds.height * 0.06)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("app_color").edgesIgnoringSafeArea(.all))
                
                if viewStore.isLoading {
                    ActivityIndicator()
                }
                NavigationLink(destination: HomeView(store: Store(initialState: HomeState(),
                                                                  reducer: homeReducer,
                                                                  environment: .live))
                    .navigationBarHidden(true),
                               isActive: viewStore.binding(\.$isHome),
                               label: { Text("") })
                NavigationLink(destination: RecoveryPasswordView(store: Store(initialState: RecoveryPasswordState(),
                                                                              reducer: recoveryPasswordReducer,
                                                                              environment: .live))
                    .navigationBarHidden(true),
                               isActive: viewStore.binding(\.$isRecover),
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: Store(initialState: SignInState(),
                               reducer: signInReducer,
                                environment: SignInEnvironment(signInClient: .live, mainQueue: .main)))
    }
}
