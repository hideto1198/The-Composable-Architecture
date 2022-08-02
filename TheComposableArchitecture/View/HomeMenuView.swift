//
//  HomeMenuView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/29.
//

import SwiftUI

struct HomeMenuView: View {
    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: EmptyView(), label: {
                        MenuView(title: "予約")
                    })
                    .offset(x: bounds.width * 0.3)
                    Divider()
                    NavigationLink(destination: EmptyView(), label: {
                        MenuView(title: "お問い合わせ")
                    })
                    .offset(x: bounds.width * 0.3)
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 50)
                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct HomeMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuView()
    }
}
