//
//  Array.swift
//  MyCare
//
//  Created by Shannon Draeker on 4/23/21.
//

import Foundation

extension Collection {
    /// Safely index into any collection and get a nil result rather than an error if the index was out of bounds
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
