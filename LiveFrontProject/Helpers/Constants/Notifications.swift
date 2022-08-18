//
//  Notifications.swift
//
//  Created by Shannon Draeker on 7/1/21.
//

import Foundation

struct NotificationHelper {
    /// Post a notification
    static func post(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }

    /// Observe a notification
    static func observe(_ name: Notification.Name, _ action: Selector, _ observer: Any) {
        NotificationCenter.default.addObserver(observer, selector: action, name: name, object: nil)
    }

    /// Observe multiple notifications all connected to the same action
    static func observe(_ names: [Notification.Name], _ action: Selector, _ observer: Any) {
        names.forEach { NotificationCenter.default.addObserver(observer, selector: action, name: $0, object: nil) }
    }
}

/// Notification names
extension Notification.Name {
    /// When the internet status changes
    static let reachabilityChanged = Notification.Name("ReachabilityStatusChangedNotification")

    /// Update the user's profile page
//    static let updateUsersProfilePage = Notification.Name("updateUsersProfilePage")
}
