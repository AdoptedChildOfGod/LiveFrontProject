//
//  AllRules.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import Foundation

/// The top level data describing all the rules
struct AllRules: Codable {
    var count: Int?
    var results: [Rule]?
}
