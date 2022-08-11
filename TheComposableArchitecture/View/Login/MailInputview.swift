//
//  MailInputview.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct MailInputview: View {
    @Binding var email: String
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "envelope")
            TextField("メールアドレス", text: self.$email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        }
        .frame(width: bounds.width * 0.9, height: bounds.height * 0.05)
    }
}

struct MailInputview_Previews: PreviewProvider {
    static var previews: some View {
        MailInputview(email: .constant(""))
    }
}
