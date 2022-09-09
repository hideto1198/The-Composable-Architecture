//
//  TheComposableArchitectureApp.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI
import UserNotifications
import ComposableArchitecture
import FirebaseCore
import FirebaseMessaging


public let bounds: CGRect = UIScreen.main.bounds

class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey: String = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: { _, _ in })
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        return UIBackgroundFetchResult.newData
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Unable to register for remote notification: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("APNs token retrieved: \(deviceToken)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        debugPrint(userInfo)
        
        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        debugPrint(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict)
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
                                environment: .init(mainQueue: .main, authenticationClient: .live)
                            )
            )
        }
    }
}
