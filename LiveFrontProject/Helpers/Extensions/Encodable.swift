//
//  Encodable.swift
//  MyCare
//
//  Created by Shannon Draeker on 4/20/21.
//

import Foundation

extension Encodable {
    func toJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.asString
    }
}

extension Dictionary where Key: Codable, Value: Codable {
    func toJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.asString
    }
}

extension String {
    func toObject<T: Decodable>(ofType _: T.Type) -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(T.self, from: data)
    }

    func tryToObject<T: Decodable>(ofType _: T.Type) throws -> T? {
        guard let data = asData else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(T.self, from: data)
    }
}

extension Data {
    func toObject<T: Decodable>(ofType _: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(T.self, from: self)
    }

    func tryToObject<T: Decodable>(ofType _: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: self)
    }
}
