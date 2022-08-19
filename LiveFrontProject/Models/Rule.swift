//
//  Rule.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import Foundation

/// An individual rule that may or may not have subsections
struct Rule: Codable {
    var name: String?
    var index: String?
    var desc: String?

    var url: String?

    var subsections: [Subsection]?
}

/// A subsection of a rule, with a link the details of the subsection
struct Subsection: Codable {
    var name: String?
    var index: String?
    var url: String?
}
