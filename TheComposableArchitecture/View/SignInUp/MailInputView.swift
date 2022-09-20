//
//  MailInputView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct MailInputView: View {
    @Binding var email: String
    var title: String = "メールアドレス"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
            ZStack(alignment: .trailing) {
                TextField("", text: self.$email)
                    .padding(.leading, 5)
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

struct MailInputView_Previews: PreviewProvider {
    static var previews: some View {
        MailInputView(email: .constant(""))
    }
}
