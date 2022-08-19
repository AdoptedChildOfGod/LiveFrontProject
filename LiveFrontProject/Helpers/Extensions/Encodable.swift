//
//  Encodable.swift
//  MyCare
//
//  Created by Shannon Draeker on 4/20/21.
//

import Foundation

extension Encodable {
    /// Convert an encodable object to a JSON formatted string
    func toJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.asString
    }
}

extension Dictionary where Key: Codable, Value: Codable {
    /// Convert a dictionary to a JSON formatted string
    func toJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.asString
    }
}

extension String {
    /// Convert a JSON formatted string to an object, returning nil if the string cannot be decoded
    func toObject<T: Decodable>(ofType _: T.Type) -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(T.self, from: data)
    }

    /// Convert a JSON formatted string to an object, throwing an error if the string cannot be decoded
    func tryToObject<T: Decodable>(ofType _: T.Type) throws -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(T.self, from: data)
    }
}

extension Data {
    /// Convert data to an object, returning nil if the string cannot be decoded
    func toObject<T: Decodable>(ofType _: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(T.self, from: self)
    }

    /// Convert data to an object, throwing an error if the string cannot be decoded
    func tryToObject<T: Decodable>(ofType _: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: self)
    }
}
