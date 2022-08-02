//
//  TheComposableArchitectureApp.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import FirebaseCore
import ComposableArchitecture

public let bounds: CGRect = UIScreen.main.bounds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TheComposableArchitectureApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView(store:
                            Store(
                                initialState: LaunchState(),
                                reducer: launchReducer,
                                environment: .init(mainQueue: .main)
                            )
            )
        }
    }
}
