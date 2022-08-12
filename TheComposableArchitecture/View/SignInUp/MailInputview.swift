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
        VStack(alignment: .leading) {
            Text("メールアドレス")
            ZStack(alignment: .trailing) {
                TextField("", text: self.$email)
                    .padding(.leading)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color.white
                        .opacity(0.2)
                        .cornerRadius(5)
                        .frame(height: bounds.height * 0.05))
            }
        }
        .padding(.horizontal, 15)
    }
}

struct MailInputview_Previews: PreviewProvider {
    static var previews: some View {
        MailInputview(email: .constant(""))
    }
}
