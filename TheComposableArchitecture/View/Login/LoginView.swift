//
//  LoginView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("LOGO")
                .resizable()
                .frame(width: bounds.width * 0.4, height: bounds.width * 0.4)
            Spacer()
                .frame(height: bounds.height * 0.05)
            MailInputview(email: .constant(""))
            PasswordInputView(password: .constant(""))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("app_color").edgesIgnoringSafeArea(.all))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
