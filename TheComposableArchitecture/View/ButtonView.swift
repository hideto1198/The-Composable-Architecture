//
//  ButtonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray, lineWidth: 1)
                Text("\(text)")
                    .foregroundColor(.primary)
            }
            .frame(width: bounds.width * 0.8, height: bounds.height * 0.06)
            .background(Color.white.opacity(0.2))
            Spacer()
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "追加")
    }
}
