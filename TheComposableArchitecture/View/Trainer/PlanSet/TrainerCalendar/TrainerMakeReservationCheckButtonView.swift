//
//  TrainerMakeReservationCheckButtonView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerMakeReservationCheckButtonView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    
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

struct TrainerMakeReservationCheckButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerMakeReservationCheckButtonView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                                         reducer: trainerMakeReservationReducer,
                                                                         environment: .live)))
    }
}
