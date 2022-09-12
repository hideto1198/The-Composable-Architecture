//
//  PlaceSelectView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import SwiftUI
import ComposableArchitecture

struct PlaceSelectView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    let places: [String] = ["未選択", "板垣店", "二の宮店"]
    
    var body: some View {
        HStack {
            Text("場所")
            Spacer()
            if #available(iOS 15, *) {
                Picker("", selection: viewStore.binding(\.$placeSelector)){
                    ForEach(places.indices, id: \.self) { i in
                        Text("\(places[i])")
                            .tag(i)
                    }
                }
                .onChange(of: viewStore.placeSelector) { _ in
                    viewStore.send(.onSelectPlace)
                }
            } else {
                Picker(selection: viewStore.binding(\.$placeSelector), label: Text("\(places[viewStore.placeSelector])")){
                    ForEach(places.indices, id: \.self) { i in
                        Text("\(places[i])")
                            .tag(i)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewStore.placeSelector) { _ in
                    viewStore.send(.onSelectPlace)
                }
                .padding(.trailing)
            }
        }
    }
}

struct PlaceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSelectView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                   reducer: makeReservationReducer,
                                                   environment: .live)))
    }
}
