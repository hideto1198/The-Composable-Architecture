//
//  CancelButtonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI

struct CancelButtonView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .stroke()
            Text("予約キャンセル")
                .font(.custom("", size: 11))
                .foregroundColor(.red)
        }
        .frame(width: bounds.width * 0.35, height: bounds.height * 0.03)
    }
}

struct CancelButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CancelButtonView()
    }
}
