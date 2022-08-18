//
//  CrashlyticsHelper.swift
//  Glance
//
//  Created by Shannon Draeker on 2/16/21.
//  Copyright © 2021 DigitalAwesome. All rights reserved.
//

// import FirebaseCrashlytics
import Foundation

struct CrashlyticsHelper {
    /// Set a value in Crashlytics so that the crashes are associated with helpful key-value pairs of information
    static func set(_: String, for _: String) {
//        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }

    /// Print a message and send a record of it to Crashlytics
    static func log(_ message: String = "", _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        let output = "~*~*~*~*~*~* \(message.isEmpty ? "Hi there! " : message)\(message.isEmpty ? "" : ". ")Logged from file \(file) in function \(function) on line \(line) ~*~*~*~*~*~*"
        print(output)
//        Crashlytics.crashlytics().log(output)
    }

    /// Print a message and send a record of it to Crashlytics as an error when a variable was unexpectedly nil
    static func recordUnexpectedNil(_ variableName: String, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        record("\(variableName) was unexpectedly nil", file, function, line)
    }

    /// Print an error and send a record of it to Crashlytics both as a log and an error
    static func record(_ error: Error, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        log("ERROR: \(error) - \(error.localizedDescription)", file, function, line)
//        Crashlytics.crashlytics().record(error: error)
    }

    /// If there's an error, print it and send a record of it to Crashlytics both as a log and an error
    static func recordIfError(_ error: Error?, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        if let error = error { record(error, file, function, line) }
    }

    /// Print a custom string message and send a record of it to Crashlytics both as a log and an error
    static func record(_ errorMessage: String, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        record(CustomError.customError(errorMessage), file, function, line)
    }

    /// A custom error class for being able to record any arbitrary string as an error to Crashlytics
    private enum CustomError: LocalizedError {
        case customError(String)

        var errorDescription: String? {
            switch self {
            case let .customError(message):
                return message
            }
        }
    }
}
