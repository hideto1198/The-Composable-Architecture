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
                    Image("LOGO")
                        .resizable()
                        .frame(width: bounds.width * 0.4, height: bounds.width * 0.4)
                    Spacer()
                        .frame(height: bounds.height * 0.05)
                    if viewStore.showButton {
                        SignInUpWithAppleButton(buttonType: .signUp,
                                                completion: { result in
                                                    switch result {
                                                    case .success(_):
                                                        viewStore.send(.onTapWithApple)
                                                        return
                                                    case .failure(_):
                                                        return
                                                    }
                                                })
                            .frame(width: bounds.width * 0.8, height: bounds.height * 0.06)
                        Button(
                            action: {
                                viewStore.send(.onTapWithEmail, animation: .easeIn)
                            }
                        ){
                            ButtonView(text: "メールアドレスで登録")
                        }
                    }
                    if viewStore.withEmail {
                        SignUpWithEmailView(viewStore: viewStore)
                    }
                    Spacer()
                }
                NavigationLink(
                    destination: RegisterView(store: Store(initialState: RegisterState(),
                                                           reducer: registerReducer,
                                                           environment: .live))
                        .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isRegister),
                    label: { Text("") }
                )
                if viewStore.isLoading {
                    ActivityIndicator()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("app_color").edgesIgnoringSafeArea(.all))
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
