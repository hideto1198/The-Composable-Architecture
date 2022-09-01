//
//  TrainerHomeHeaderView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct TrainerHomeHeaderView: View {
    let store: Store<TrainerHomeState, TrainerHomeAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                ZStack {
                    HStack {
                        Button(
                            action: {
                                viewStore.send(.onTapMenu, animation: .easeIn)
                            }
                        ){
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: bounds.width * 0.06, height: bounds.width * 0.06)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("BONA FIDE")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Image("LOGO")
                            .resizable()
                            .frame(width: bounds.width * 0.076, height: bounds.width * 0.076)
                            .onTapGesture(count: 3,perform: {
                                viewStore.send(.onTapLogo, animation:.easeInOut)
                            })
                    }
                }
                .padding(.horizontal)
                Divider()
            }
        }
    }
}

struct TrainerHomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerHomeHeaderView(store: Store(initialState: TrainerHomeState(),
                                           reducer: trainerHomeReducer,
                                           environment: .live))
    }
}
