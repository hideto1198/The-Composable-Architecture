//
//  SignUpWithAppleClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/15.
//

import Foundation
import ComposableArchitecture
import Combine
import AuthenticationServices
import CryptoKit

struct SignUpWithAppleClient {
    var fetch: () -> Effect<Bool, Failure>
    struct Failure: Error, Equatable {}
}

extension SignUpWithAppleClient {
    static let live = SignUpWithAppleClient(fetch: {
        Effect.task {
            
            return true
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}

// MARK: - Appleのログインフロー
fileprivate var currentNonce: String?

func startSignInWithAppleFlow() {
    let nonce: String = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = nonce
    
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
