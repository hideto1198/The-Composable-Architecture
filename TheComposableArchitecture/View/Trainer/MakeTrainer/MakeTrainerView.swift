//
//  MakeTrainerView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/24.
//

import SwiftUI
import ComposableArchitecture

struct MakeTrainerView: View {
    @Environment(\.presentationMode) var presentaionMode
    let store: Store<MakeTrainerState, MakeTrainerAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    AppHeaderView(title: "トレーナー登録画面")
                    MakeTrainerPasswordInputView(password: viewStore.binding(get: \.password, send: MakeTrainerAction.onPasswordChanged))
                        .padding(.top)
                    MakeTrainerPathInputView(text: viewStore.binding(get: \.path_text, send: MakeTrainerAction.onPathChanged))
                        .padding(.top)
                    StoreSelectorView(viewStore: viewStore)
                        .padding(.top)
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.onTapLogin)
                        }
                    ){
                        ButtonView(text: "ログイン")
                    }
                    .padding(.bottom)
                }
                if viewStore.isLoading {
                    LoadingView()
                }
                NavigationLink(
                    destination: TrainerHomeView(store: Store(initialState: TrainerHomeState(),
                                                                    reducer: trainerHomeReducer,
                                                                    environment: .live))
                    .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isTrainer),
                    label: { Text("") }
                )
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if value.startLocation.x <= bounds.width * 0.09 && value.startLocation.x * 1.1 < value.location.x{
                            withAnimation(){
                                self.presentaionMode.wrappedValue.dismiss()
                            }
                        }
                    }
            )
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct MakeTrainerView_Previews: PreviewProvider {
    static var previews: some View {
        MakeTrainerView(store: Store(initialState: MakeTrainerState(),
                                     reducer: makeTrainerReducer,
                                     environment: .live))
    }
}
