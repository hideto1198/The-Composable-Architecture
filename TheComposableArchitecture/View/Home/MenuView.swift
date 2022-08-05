//
//  MenuView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/31.
//

import SwiftUI

struct MenuView: View {
    var title: String
    var body: some View {
        HStack {
            Text("\(title)")
            Spacer()
        }
        .frame(width: bounds.width * 0.6, height: bounds.height * 0.05)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(title: "予約")
    }
}