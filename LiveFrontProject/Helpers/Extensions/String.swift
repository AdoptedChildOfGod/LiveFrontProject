//
//  String.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Foundation

extension String {
    // MARK: - Validation

    /// Check if a string is blank or not (better than checking if it's empty or not because it will check if it only contains white spaces)
    var isBlank: Bool { trimmingCharacters(in: CharacterSet.whitespaces).isEmpty }

    // MARK: - Helper Methods

    /// Convert to data using the default .utf8 encoding
    var asData: Data? { data(using: .utf8) }

    /// Cap a string at a maximum length without throwing an error
    func capAt(_ maxLength: Int) -> String { (count > maxLength) ? (String(prefix(maxLength)) + "...") : self }

    // MARK: - Subscripting

    /// Allows the string to be subscripted like an array

    subscript(i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript(r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension Data {
    var asString: String? { String(data: self, encoding: .utf8) }
}
