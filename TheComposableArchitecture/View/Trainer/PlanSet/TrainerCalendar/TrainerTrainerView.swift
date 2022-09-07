//
//  TrainerTrainerView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture

struct TrainerTrainerView: View {
    let viewStore: ViewStore<TrainerMakeReservationState, TrainerMakeReservationAction>
    var trainer: TrainerEntity
    var body: some View {
        ZStack {
            Color("background")
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.8), radius: 3, x: 2, y: 6)
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("app_color"))
            HStack {
                ZStack {
                    HStack {
                        Image("LOGO")
                            .resizable()
                            .cornerRadius(15)
                    }
                }
                .frame(width: bounds.width * 0.31, height: bounds.height * 0.2)
                .padding(.leading)
                Spacer()
                VStack {
                    Text("- profile -")
                        .padding(.top)
                    HStack {
                        Text("名前：\(trainer.trainerName)")
                            .font(.custom("", size: 13))
                        Spacer()
                    }
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.trainerAction(.onTapTrainer(trainer)), animation: .easeInOut)
                        }
                    ){
                        ZStack {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray, lineWidth: 1)
                            Text("選択")
                                .font(.custom("", size: 15))
                        }
                        .frame(width: bounds.width * 0.45, height: bounds.height * 0.025)
                    }
                    .padding(.bottom)
                }
                Spacer()
            }
        }
        .frame(width: bounds.width * 0.85, height: bounds.height * 0.23)
        
    }
}

struct TrainerTrainerView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerTrainerView(viewStore: ViewStore(Store(initialState: TrainerMakeReservationState(),
                                                      reducer: trainerMakeReservationReducer,
                                                      environment: .live)),
                           trainer: TrainerEntity())
    }
}
