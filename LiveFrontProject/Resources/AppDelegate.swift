//
//  AppDelegate.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Firebase
import FirebaseCrashlytics
import UIKit
// import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: - Properties

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var coordinator: Coordinator!

    // MARK: - App Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the coordinator and navigate to the first page of the app
        let navigationController = UINavigationController()
        coordinator = Coordinator(createWith: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator.start()

        // Set up Firebase
        FirebaseApp.configure()

//        // Set up the messaging delegate
//        Messaging.messaging().delegate = self

        // Set up purchase observers
        IAPManager.shared.startObserving()
        IAPManager.shared.loadAllProducts()

        // Register for remote notifications
        requestRemoteNotifications(application)

        // Listen for changes in internet reachability status
        Reachability().monitorReachabilityChanges()

        return true
    }

    // MARK: - Notifications

    private func requestRemoteNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            CrashlyticsHelper.recordIfError(error)

            // Save the user's preference
//            UserDefaults.standard.set(grantedPermission, forKey: UserDefaultKeys.notificationsEnabledKey)
        }

        application.registerForRemoteNotifications()
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // For debugging
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token is \(tokenString)")
    }

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        // Get the user's FCM token for testing purposes
//        print("user's FCM token is \(fcmToken)")
//    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("got here to \(#function) and \(userInfo)")
    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("got here to \(#function) and \(userInfo)")

        completionHandler(.noData)
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler _: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("got here to \(#function) and \(notification)")
    }
}
