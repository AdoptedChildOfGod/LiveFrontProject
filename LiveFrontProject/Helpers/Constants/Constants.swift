//
//  Constants.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Foundation

// A place to store misc constants that are used throughout the app

// MARK: - Misc

/// Commonly used return types
typealias ResultCompletion = (Result<Bool, CustomError>) -> Void
typealias ResultCompletionWith<T> = (Result<T, CustomError>) -> Void
