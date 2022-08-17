//
//  SignInUpWithAppleButton.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/15.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

struct SignInUpWithAppleButton: UIViewRepresentable {
    var buttonType: ASAuthorizationAppleIDButton.ButtonType
    var completion: (Result<Bool, Error>) -> Void
    
    init(buttonType: ASAuthorizationAppleIDButton.ButtonType, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.completion = completion
        self.buttonType = buttonType
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: buttonType, authorizationButtonStyle: .white)
        button.addTarget(context.coordinator,
                         action: #selector(Coordinator.startSignInWithAppleFlow),
                         for: .touchUpInside)
        return button
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


fileprivate var currentNonce: String?
private struct AuthError: Error {}

final class Coordinator: NSObject {
    var parent: SignInUpWithAppleButton
    
    init(_ parent: SignInUpWithAppleButton){
        self.parent = parent
        super.init()
    }
    
    // MARK: - Appleのログインフロー
    @objc func startSignInWithAppleFlow() {
        let nonce: String = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - ログインリクエスト用のランダムな文字列を生成
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result: String = ""
        var remainingLength: Int = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyByte failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    // MARK: - SHA256ハッシュを生成
    private func sha256(_ input: String) -> String {
        let inputDate = Data(input.utf8)
        let hashedDate = SHA256.hash(data: inputDate)
        let hashString = hashedDate.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

extension Coordinator: ASAuthorizationControllerDelegate {
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                self.parent.completion(.failure(AuthError()))
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                self.parent.completion(.failure(AuthError()))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.parent.completion(.failure(AuthError()))
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.parent.completion(.failure(AuthError()))
                    return
                }
                // TODO: - 認証成功フロー
                if let user = authResult?.user {
                    switch self.parent.buttonType {
                    case .signUp:
                        self.parent.completion(.success(true))
                    case .signIn:
                        let db = Firestore.firestore()
                        db.collection("USERS").document("\(user.uid)").getDocument { documentSnapshot, error in
                            if let documentSnapshot = documentSnapshot {
                                if !documentSnapshot.exists {
                                    self.parent.completion(.failure(AuthError()))
                                } else {
                                    self.parent.completion(.success(true))
                                }
                            } else {
                                self.parent.completion(.failure(AuthError()))
                            }
                        }
                    default:
                        self.parent.completion(.failure(AuthError()))
                    }
                }
            }
        }
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 認証失敗フロー
        debugPrint(error.localizedDescription)
    }
}

extension Coordinator: ASAuthorizationControllerPresentationContextProviding {
    // 認証ダイアログを表示するためのUIWindowを返すためのコールバック
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
}



