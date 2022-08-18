//
//  APIStrings.swift
//
//  Created by Shannon Draeker on 10/27/20.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case patch = "PATCH"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Generic API Strings

struct APIStrings {
    /// The base url for all the requests
     static var baseURL = "https://parkyourself.digitalawesomeapps.com"

    /// The headers for the requests
    static let jsonType = "application/json; charset=utf-8"
    static let wwwType = "application/x-www-form-urlencoded"
    static let contentType = "Content-Type"
    static let acceptHeader = "Accept"
    static let bearer = "Bearer"
    static let authorization = "Authorization"
}

// MARK: - URLs

struct URLs {
    /// Authentication endpoints
    static let login = "oauth/token"
    static let register = "/api/v1/users/register"
    static let sendPasswordReset = "api/v1/password/email"
    static let resetPassword = "api/v1/password/reset"
    static let updateProfile = "api/v1/users/profile"
    static let getUser = "api/v1/user"
}

// MARK: - Data Passed to the API

struct APIKeys {
    /// The keys for registering and updating user information
    static let clientID = "client_id"
    static let clientIDValue = "" // TODO: - client id
    static let clientSecret = "client_secret"
    static let clientSecretValue = "" // TODO: - client secret
    static let grantType = "grant_type"
    static let name = "name"
    static let username = "username"
    static let email = "email"
    static let password = "password"
    static let passwordConfirmation = "password_confirmation"
}
