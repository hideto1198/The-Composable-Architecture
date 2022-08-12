//
//  InputTextField.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct InputTextField: View {
    var title: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
            ZStack(alignment: .trailing) {
                TextField("", text: self.$text)
                    .padding(.leading)
                    .background(Color.white
                        .opacity(0.2)
                        .cornerRadius(5)
                        .frame(height: bounds.height * 0.05))
            }
        }
    }
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField(title: "姓", text: .constant("あああああ"))
    }
}
