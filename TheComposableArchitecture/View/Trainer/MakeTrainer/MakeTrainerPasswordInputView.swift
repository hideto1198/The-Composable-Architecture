//
//  MakeTrainerPasswordInputView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI

struct MakeTrainerPasswordInputView: View {
    @State var isSecured: Bool = true
    @Binding var password: String
    var title: String = "パスワード"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
            ZStack(alignment: .trailing) {
                Group {
                    if self.isSecured {
                        SecureField("", text: self.$password)
                    } else {
                        TextField("", text: self.$password)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .background(Color.white
                    .opacity(0.2)
                    .cornerRadius(5)
                    .frame(height: bounds.height * 0.05))
                Button(
                    action: {
                        self.isSecured.toggle()
                    }
                ){
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
            }
        }
        .padding(.horizontal, 15)
    }
}

struct MakeTrainerPasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        MakeTrainerPasswordInputView(isSecured: true, password: .constant("text"))
    }
}
