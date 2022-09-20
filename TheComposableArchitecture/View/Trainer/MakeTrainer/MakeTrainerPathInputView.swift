//
//  MakeTrainerPathInputView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI

struct MakeTrainerPathInputView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("画像パス")
            ZStack(alignment: .trailing) {
                TextField("", text: self.$text)
                    .padding(.leading, 5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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

struct MakeTrainerPathInputView_Previews: PreviewProvider {
    static var previews: some View {
        MakeTrainerPathInputView(text: .constant("test_trainer"))
    }
}
