//
//  HomeMenuView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import SwiftUI

struct HomeMenuView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("予約")
                    .offset(x: bounds.width * 0.3)
                Divider()
                Text("お問合せ")
                    .offset(x: bounds.width * 0.3)
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 50)
            Spacer()
        }
        .background(Color.white)
        .offset(x: bounds.width * -0.3)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct HomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuView()
    }
}
