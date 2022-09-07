//
//  MakeReservationCheckButtonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/17.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationCheckButtonView: View {
    let viewStore: ViewStore<MakeReservationState, MakeReservationAction>
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: { viewStore.send(.onTapCheckButton) }
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                        Image(systemName: "calendar")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: bounds.width * 0.07, height: bounds.width * 0.07)
                        if viewStore.reservations.count != 0 {
                            VStack {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.red)
                                        Text("\(viewStore.reservations.count)")
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: bounds.width * 0.13, height: bounds.height * 0.03)
                                    .offset(x: bounds.width * 0.03, y: bounds.width * 0.025 * -1)
                                }
                            }
                        }
                    }
                    .frame(width: bounds.width * 0.09, height: bounds.width * 0.09)
                    .padding([.trailing, .bottom])
                }
            }
        }
    }
}

struct MakeReservationCheckButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationCheckButtonView(viewStore: ViewStore(Store(initialState: MakeReservationState(),
                                                                  reducer: makeReservationReducer,
                                                                  environment: .live)))
    }
}
