//
//  SignInUpView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture
struct SignInUpView: View {
    var body: some View {
        TabView {
            SignInView(store: Store(initialState: SignInState(),
                                    reducer: signInReducer,
                                    environment: SignInEnvironment(signInClient: .live, mainQueue: .main)))
                .tabItem{
                    Image(systemName: "person")
                    Text("Sign In")
                }
            SignUpView(store: Store(initialState: SignUpState(),
                                    reducer: signUpReducer,
                                    environment: .live))
                .tabItem{
                    Image(systemName: "person.fill.badge.plus")
                    Text("Sign Up")
                }
        }
    }
}

struct SignInUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInUpView()
    }
}
