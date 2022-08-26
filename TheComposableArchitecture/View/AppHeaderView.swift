//
//  AppHeaderView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import SwiftUI

struct AppHeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
    
    var body: some View {
        VStack{
            ZStack {
                HStack {
                    Button(
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    ){
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("\(title)")
                        .padding(.vertical)
                    Spacer()
                }
            }
            Divider()
        }
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppHeaderView(title: "ヘッダービュー")
    }
}
