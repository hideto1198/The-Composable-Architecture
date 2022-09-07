//
//  InputReasonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct InputReasonView: View {
    let viewStore: ViewStore<InputReasonState, InputReasonAction>
    let items: [String] = ["体験","パーソナルトレーニング","ペアトレーニング","休み","その他"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("primary_white"))
            RoundedRectangle(cornerRadius: 10)
                .stroke()
            VStack {
                Group {
                    HStack {
                        Text("項目")
                            .foregroundColor(Color.primary)
                            .padding(.horizontal)
                        Picker(selection: viewStore.binding(\.$itemSelector), label: Text("")) {
                            ForEach(items.indices, id: \.self) { i in
                                Text("\(items[i])")
                                    .tag(i)
                            }
                        }
                    }
                    Text("備考を入力")
                        .font(.custom("", size: 15))
                    TextField("", text: viewStore.binding(\.$note))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top)
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: {}
                    ){
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                        Text("確定")
                    }
                    .padding(.trailing)
                    Button(
                        action: {}
                    ){
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                        Text("キャンセル")
                            .foregroundColor(.red)
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
        }
        .frame(width: bounds.width * 0.85, height: bounds.height * 0.3)
    }
}

struct InputReasonView_Previews: PreviewProvider {
    static var previews: some View {
        InputReasonView(viewStore: ViewStore(Store(initialState: InputReasonState(),
                                                   reducer: inputReasonReducer,
                                                   environment: .live)))
    }
}
