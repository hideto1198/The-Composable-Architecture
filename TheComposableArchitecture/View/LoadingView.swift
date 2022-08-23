//
//  LoadingView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/19.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color("primary_white"))
                        .frame(width: bounds.width * 0.4, height: bounds.height * 0.15)
                    VStack {
                        ActivityIndicator()
                        Text("通信中")
                            .fontWeight(.bold)
                            .padding(.top)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(Color.gray
            .opacity(0.6)
            .edgesIgnoringSafeArea(.all))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
