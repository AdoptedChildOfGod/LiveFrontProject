//
//  String.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Foundation

extension String {
    // MARK: - Helper Methods

    /// Convert to data using the default .utf8 encoding
    var asData: Data? { data(using: .utf8) }

    /// Cap a string at a maximum length without throwing an error
    func capAt(_ maxLength: Int) -> String { (count > maxLength) ? (String(prefix(maxLength)) + "...") : self }
}

extension Data {
    // MARK: - Helper Methods

    /// Quickly see a data object as a string using the default utf8 encoding
    var asString: String? { String(data: self, encoding: .utf8) }
}
