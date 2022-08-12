//
//  BirthdaySelectorView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct BirthdaySelectorView: View {
    @Binding var date: Date
    var body: some View {
        HStack {
            VStack {
                Text("誕生日(任意)")
                DatePicker(selection: self.$date,
                           displayedComponents: .date,
                           label: { Text("") })
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ja_JP"))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct BirthdaySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdaySelectorView(date: .constant(Date()))
    }
}
