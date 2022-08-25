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
        VStack {
            HStack {
                Text("\(title)")
                    .foregroundColor(.primary)
                Spacer()
            }
            .frame(height: bounds.height * 0.05)
            .offset(x: bounds.width * 0.3)
            Divider()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(title: "予約")
    }
}
