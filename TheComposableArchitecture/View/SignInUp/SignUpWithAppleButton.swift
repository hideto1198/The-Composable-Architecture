//
//  SignUpWithAppleButton.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/15.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignUpWithAppleButton: UIViewRepresentable {
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
        return button
    }
    
}
