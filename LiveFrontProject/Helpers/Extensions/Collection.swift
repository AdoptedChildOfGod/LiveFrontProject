//
//  Array.swift
//  MyCare
//
//  Created by Shannon Draeker on 4/23/21.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
