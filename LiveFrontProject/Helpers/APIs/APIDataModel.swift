//
//  APIDataModel.swift
//  Glance
//
//  Created by Shannon Draeker on 3/15/21.
//  Copyright © 2021 DigitalAwesome. All rights reserved.
//

import Foundation

struct APIDataModel<Attributes: Codable, Relationships: Codable>: Codable {
    var data: APIModel<Attributes, Relationships>?
}

struct APIDataArrayModel<Attributes: Codable, Relationships: Codable>: Codable {
    var data: [APIModel<Attributes, Relationships>]?
}

struct APIModel<Attributes: Codable, Relationships: Codable>: Codable {
    var type: String?
    var id: Int?
    var attributes: Attributes?
    var relationships: Relationships?
}

struct ResultFormat: Codable {
    var success: Bool
    var message: String
}

struct Empty: Codable {}

struct APIErrorModel: Codable {
    private var message: String?
    private var errors: [String: [String]]?

    var errorMessage: String {
        var outputString = message ?? "ERROR"
        guard let errors = errors else { return outputString }

        for (key, value) in errors {
            outputString += "\n\(key): \(value.joined(separator: ", "))"
        }

        return outputString
    }
}

class APIOtherErrorModel: Codable {
    private var errors: APIErrorMessage?

    struct APIErrorMessage: Codable {
        var messages: String?
    }

    var errorMessage: String { "ERROR\n\(errors?.messages ?? "UNKNOWN ERROR")" }
}

struct APISuccessMessage: Codable {
    var success: Bool
    var message: String?
}
