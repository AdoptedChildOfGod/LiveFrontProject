//
//  MagicStrings.swift
//
//  Created by Shannon Draeker on 5/24/21.
//

import Foundation

// A place to store all the strings used throughout the app to avoid magic strings

// MARK: - Strings for Screens

extension String {
    /// Multiple
    static let back = "Back"

    /// Keyboard
    static let required = "Required"
    static let requiredFull = "You must enter a "
    static let requiredFullYour = "You must enter your "
    static let email = "Email"
    static let invalidEmail = "Invalid Email"
    static let invalidEmailFull = "Make sure you enter a valid email address"
    static let invalidPassword = "Invalid Password"
    static let invalidPasswordFull = "Your password must be 8 or more characters long & contain a mix of upper & lower case letters and numbers"
    static let password = "Password"
    static let passwordsMatch = "Passwords Don't Match"
    static let passwordsMatchFull = "The passwords you have entered don't match - please try again"
    static let confirm = "Confirm"
    static let mustConfirm = "You must confirm your "
    static let success = "Success"
    static let successfullySwitched = "Successfully switched api environment to "

    /// Image Picker Protocol
    static let addPhoto = "Add Photo"
    static let chooseFromLibrary = "Choose from Phone's Library"
    static let takePhoto = "Take Photo"
    static let notAvailable = "Not Available"
    static let cameraNotAvailable = "The photo library is not available - check that you have enabled permissions to access the photo library in your phone's settings"

    /// Apple Sign In
    static let unavailable = "Unavailable"
    static let appleSignInUnavailable = "Apple Sign In is not available right now - try to sign up with a username and password instead"

    /// Textfield Placeholders
    static let emailPlaceholder = "Enter email here"
    static let usernamePlaceholder = "Enter username here"
    static let passwordPlaceholder = "Enter password here"
    static let confirmPasswordPlaceholder = "Confirm password here"

    /// Sign In
    static let login = "Login"
    static let register = "Register"
    static let forgotPassword = "Forgot Password"
    static let resetPassword = "Reset Password"
    static let resetPasswordFull = "Enter the email address associated with your account to send the code to reset your password"
    static let sendCode = "Send Code"
    static let emailSent = "Email Sent"
    static let emailSentFull = "A reset code has been sent to your email - please allow a few minutes for the email to arrive"

    /// No internet view
    static let noInternetMessage = "There is no internet connection" // TODO: - need copy for this
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
    static let noInternetFull = "You must be connected to the internet in order to use Glance. Please check your internet connection and try again"
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
