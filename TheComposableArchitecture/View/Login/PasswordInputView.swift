//
//  PasswordInputView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct PasswordInputView: View {
    @Binding var password: String
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "key")
            TextField("パスワード", text: self.$password)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        }
        .frame(width: bounds.width * 0.9, height: bounds.height * 0.05)
    }
}

struct PasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordInputView(password: .constant(""))
    }
}
