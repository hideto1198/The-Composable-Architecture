//
//  SexSelectorView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI

struct SexSelectorView: View {
    @Binding var selector: Int
    var body: some View {
        VStack(alignment: .leading){
            Text("性別(任意)")
            Picker(selection: self.$selector, label: Text("")){
                Text("-")
                    .tag(0)
                Text("男性")
                    .tag(1)
                Text("女性")
                    .tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
    }
}

struct SexSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SexSelectorView(selector: .constant(0))
    }
}
