//
//  AppDelegate.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: - Properties

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var coordinator: Coordinator!

    // MARK: - App Lifecycle

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the coordinator and navigate to the first page of the app
        let navigationController = UINavigationController()
        coordinator = Coordinator(createWith: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator.start()

        // Listen for changes in internet reachability status
        Reachability().monitorReachabilityChanges()

        return true
    }
}
