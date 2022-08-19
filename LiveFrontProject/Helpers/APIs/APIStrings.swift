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
    /// The headers for the requests
    static let jsonType = "application/json; charset=utf-8"
    static let wwwType = "application/x-www-form-urlencoded"
    static let contentType = "Content-Type"
    static let acceptHeader = "Accept"
    static let bearer = "Bearer"
    static let authorization = "Authorization"
}

// MARK: - URLs

/// API documentation can be found at https://www.dnd5eapi.co/docs/#overview--introduction

struct URLs {
    /// The base url for all the requests
    static var base = "https://www.dnd5eapi.co"

    /// Endpoints
    static let rules = "api/rules"
}
