//
//  MagicStrings.swift
//
//  Created by Shannon Draeker on 5/24/21.
//

import Foundation

// A place to store all the strings used throughout the app to avoid magic strings

// TODO: - convert to localized strings

// MARK: - Strings for Screens

extension String {
    /// No internet view
    static let noInternetMessage = "There is no internet connection"
}

// MARK: - Strings for Alerts

extension String {
    /// Multiple
    static let ok = "Ok"
    static let cancel = "Cancel"
    static let save = "Save"
    static let dismiss = "Dismiss"
    static let error = "ERROR"

    /// Expired Token
    static let expired = "Session Expired"
    static let expiredFull = "Your session has expired - please sign in again"

    /// No Internet
    static let noInternet = "No Internet Connection"
    static let noInternetFull = "You must be connected to the internet in order to use this app. Please check your internet connection and try again"
}

// MARK: - Misc

extension String {
    /// Misc
    static let space = " "
    var plural: String { self + "s" }
}

// MARK: - User Default Keys

extension String {
    /// The information from Apple sign in
    static let appleFirstName = "appleFirstName"
    static let appleLastName = "appleLastName"
    static let appleEmail = "appleEmail"

    /// The access token
    static let accessToken = "accessToken"
}
