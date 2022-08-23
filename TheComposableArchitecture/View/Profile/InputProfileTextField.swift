//
//  InputProfileTextField.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI

struct InputProfileTextField: View {
    var title: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
            ZStack(alignment: .trailing) {
                TextField("", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

struct InputProfileTextView_Previews: PreviewProvider {
    static var previews: some View {
        InputProfileTextField(title: "姓", text: .constant("テスト"))
    }
}
