//
//  StoreTimeSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/03.
//

import SwiftUI
import ComposableArchitecture

struct StoreTimeSelectView: View {
    let viewStore: ViewStore<StorePersonalChangeState, StorePersonalChangeAction>
    let times: [String] = [
        "9:00","9:30","10:00","10:30","11:00","11:30",
        "12:00","12:30","13:00","13:30","14:00","14:30",
        "15:00","15:30","16:00","16:30","17:00","17:30",
        "18:00","18:30","19:00","19:30","20:00","20:30",
        "21:00","21:30","22:00","22:30"
    ]
    
    var body: some View {
        HStack {
            Text("時間帯選択")
            if #available(iOS 15, *) {
                Picker(selection: viewStore.binding(\.$timeFromSelector), label: Text("")) {
                    ForEach(times.indices, id: \.self) { i in
                        Text("\(times[i])")
                            .tag(i)
                    }
                }
                .labelsHidden()
                .onChange(of: viewStore.timeFromSelector) { _ in
                    viewStore.send(.onChangeTimeFrom)
                }
                Text("~")
                Picker(selection: viewStore.binding(\.$timeToSelector), label: Text("")) {
                    ForEach(times.indices, id: \.self) { i in
                        Text("\(times[i])")
                            .tag(i)
                    }
                }
                .labelsHidden()
                .onChange(of: viewStore.timeToSelector) { _ in
                    viewStore.send(.onChangeTimeTo)
                }
            } else {
                Picker(selection: viewStore.binding(\.$timeFromSelector), label: Text("\(times[viewStore.timeFromSelector])")) {
                    ForEach(times.indices, id: \.self) { i in
                        Text("\(times[i])")
                            .tag(i)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewStore.timeFromSelector) { _ in
                    viewStore.send(.onChangeTimeFrom)
                }
                Text("~")
                Picker(selection: viewStore.binding(\.$timeToSelector), label: Text("\(times[viewStore.timeToSelector])")) {
                    ForEach(times.indices, id: \.self) { i in
                        Text("\(times[i])")
                            .tag(i)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewStore.timeToSelector) { _ in
                    viewStore.send(.onChangeTimeTo)
                }
            }
            Spacer()
        }
        .padding( .top)
    }
}

struct StoreTimeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        StoreTimeSelectView(viewStore: ViewStore(Store(initialState: StorePersonalChangeState(),
                                                       reducer: storePersonalChangeReducer,
                                                       environment: .live)))
    }
}
