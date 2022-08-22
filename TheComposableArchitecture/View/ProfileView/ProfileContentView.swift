//
//  ProfileContentView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import SwiftUI

struct ProfileContentView: View {
    var title: String
    var value: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(title)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text("\(value)")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .padding(.leading)
            Spacer()
            Image(systemName: "greaterthan")
                .padding(.trailing)
                .foregroundColor(.primary)
        }
    }
}

struct ProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileContentView(title: "名前", value: "東　秀斗")
    }
}
