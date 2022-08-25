//
//  RecoveryPasswordView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct RecoveryPasswordView: View {
    let store: Store<RecoveryPasswordState, RecoveryPasswordAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    AppHeaderView(title: "パスワード復元")
                    Text("登録済みメールアドレスにパスワード再設定用のメールを送信します。メール受信後メールの内容に従ってパスワードを再設定してください。")
                        .padding(.horizontal)
                    MailInputView(email: viewStore.binding(\.$email), title: "登録済みメールアドレス")
                        .padding([.horizontal, .top])
                    Spacer()
                    Button(
                        action: {
                            viewStore.send(.onTapSend)
                        }
                    ) {
                        ButtonView(text: "再設定メール送信")
                    }
                    .padding(.bottom)
                }
                .background(Color("app_color").edgesIgnoringSafeArea(.all))
                if viewStore.isLoading {
                    LoadingView()
                }
            }
            .alert(self.store.scope(state: \.alert),
                   dismiss: .alertDismissed)
 
        }
    }
}

struct RecoveryPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryPasswordView(store: Store(initialState: RecoveryPasswordState(),
                                          reducer: recoveryPasswordReducer,
                                          environment: .live))
    }
}
