//
//  TrainerView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/09.
//

import SwiftUI

struct TrainerView: View {
    var name: String
    var body: some View {
        ZStack {
            Color("background")
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color("app_color"))
            HStack {
                ZStack {
                    HStack {
                        Image("LOGO")
                            .resizable()
                    }
                }
                .frame(width: bounds.width * 0.31, height: bounds.height * 0.2)
                .padding(.leading)
                Spacer()
                VStack {
                    Text("- profile -")
                        .padding(.top)
                    HStack {
                        Text("名前：\(name)")
                            .font(.custom("", size: 13))
                        Spacer()
                    }
                    Spacer()
                    Button(
                        action: {}
                    ){
                        ZStack {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray, lineWidth: 1)
                            Text("選択")
                                .font(.custom("", size: 15))
                        }
                        .frame(width: bounds.width * 0.45, height: bounds.height * 0.025)
                    }
                    .padding(.bottom)
                }
                Spacer()
            }
        }
        .frame(width: bounds.width * 0.9, height: bounds.height * 0.23)
    }
}

struct TrainerView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerView(name: "テスト　トレーナー")
    }
}
