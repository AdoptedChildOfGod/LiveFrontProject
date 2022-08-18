//
//  CustomError.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Foundation

enum CustomError: LocalizedError {
    case thrownError(Error)
    case customError(String)
    case serverMessage(String)
    case noInternet
    case expiredToken
    case invalidURL
    case invalidInput
    case serverError
    case noData
    case badData
    case userTaken
    case incorrectUserPassword
    case unknownError
    case newCase

    var errorDescription: String? {
        switch self {
        case let .thrownError(error):
            // Some unknown error received from the backend
            return "The server returned an error:\n\(error.localizedDescription)"
        case let .customError(message):
            // Any custom string that we want to record to Crashlytics as an error
            return "There was an error: \(message)"
        case let .serverMessage(message):
            // When the server returns an error
            return message
        case .noInternet:
            // Would happen if the user is unable to access the internet
            return "You're not connected to the internet"
        case .expiredToken:
            // Happens when the user tries to do an operation that requires the auth token but it's expired
            return "Your session has expired - please log in again"
        case .invalidURL:
            // Should only happen if the url for the server somehow changes
            return "There was a problem fetching data from the server - please try again later"
        case .invalidInput:
            // Happens when the user enters some invalid input that can't be converted to JSON
            return "The input you entered was invalid - please try again"
        case .serverError:
            // Would happen if the server response were something other than the codes being checked by that API call
            return "There was a problem connecting with the server - please try again later"
        case .noData:
            // Would occur when trying to unwrap data from the server if the data received is 0 bytes
            return "The server returned no data"
        case .badData:
            // Would occur if the function were unable to unwrap the data from the API call - should only happen if the format of the data received from the server changes
            return "The server returned bad data - please try again later"
        case .userTaken:
            // Happens if the user tries to register with an email that already exists as a user
            return "The email you have entered is already taken - please try again or sign in with an existing account"
        case .incorrectUserPassword:
            // Happens if the user tries to login with an incorrect email or password
            return "The email or password you have entered is incorrect - please try again"
        case .unknownError:
            // Should not happen
            return "An unknown error occurred - please try again later"
        case .newCase:
            // Happens when a switch was not quite as exhaustive as expected
            return "There was an error - please contact our development team"
        }
    }
}
