//
//  InputReasonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct InputReasonView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
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
                        Spacer()
                        if #available(iOS 15, *) {
                            Picker(selection: viewStore.binding(\.inputReasonState.$itemSelector), label: Text("")) {
                                ForEach(items.indices, id: \.self) { i in
                                    Text("\(items[i])")
                                        .tag(i)
                                }
                            }
                        } else {
                            Picker(selection: viewStore.binding(\.inputReasonState.$itemSelector), label: Text("\(items[viewStore.inputReasonState.itemSelector])")) {
                                ForEach(items.indices, id: \.self) { i in
                                    Text("\(items[i])")
                                        .tag(i)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    .padding(.horizontal)
                    Text("備考を入力")
                        .font(.custom("", size: 15))
                    TextField("", text: viewStore.binding(\.inputReasonState.$note))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top)
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.inputReasonAction(.onTapDecision(viewStore.trainerTimescheduleState.selectedTime)))
                        }
                    ){
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                            Text("確定")
                        }
                        .frame(width: bounds.width * 0.3, height: bounds.height * 0.05)
                    }
                    .padding(.trailing)
                    Button(
                        action: {
                            viewStore.send(.inputReasonAction(.onTapCancel), animation: .linear)
                        }
                    ){
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                            Text("キャンセル")
                                .foregroundColor(.red)
                        }
                        .frame(width: bounds.width * 0.3, height: bounds.height * 0.05)
                    }
                    .padding(.leading)
                    Spacer()
                }
                .padding(.bottom)
            }
        }
        .frame(width: bounds.width * 0.85, height: bounds.height * 0.3)
    }
}

struct InputReasonView_Previews: PreviewProvider {
    static var previews: some View {
        InputReasonView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                   reducer: trainerMakeReservationReducer,
                                                   environment: .live)))
    }
}
