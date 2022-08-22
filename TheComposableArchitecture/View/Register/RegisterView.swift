//
//  RegisterView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

struct RegisterView: View {
    let store: Store<RegisterState, RegisterAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack(alignment: .leading) {
                    AppHeaderView(title: "基本情報登録")
                    Group {
                        HStack {
                            InputTextField(title: "姓", text: viewStore.binding(\.$firstName1))
                                .padding(.leading)
                            InputTextField(title: "名", text: viewStore.binding(\.$lastName1))
                                .padding(.trailing)
                        }
                        .padding(.bottom)
                        HStack {
                            InputTextField(title: "セイ", text: viewStore.binding(\.$firstName2))
                                .padding(.leading)
                            InputTextField(title: "メイ", text: viewStore.binding(\.$lastName2))
                                .padding(.trailing)
                        }
                        .padding(.bottom)
                        SexSelectorView(selector: viewStore.binding(\.$sexSelector))
                            .padding(.bottom)
                        BirthdaySelectorView(date: viewStore.binding(\.$date))
                    }
                    .padding(.top)
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.onTapRegister)
                        }
                    ){
                        ButtonView(text: "登録")
                    }
                }
                NavigationLink(
                    destination: HomeView(store: Store(initialState: HomeState(),
                                                       reducer: homeReducer,
                                                       environment: .live))
                        .navigationBarHidden(true),
                    isActive: viewStore.binding(\.$isHome),
                    label: { Text("") }
                )
                if viewStore.isLoading {
                    LoadingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("app_color").edgesIgnoringSafeArea(.all))
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(store: Store(initialState: RegisterState(),
                                  reducer: registerReducer,
                                  environment: .live))
    }
}
