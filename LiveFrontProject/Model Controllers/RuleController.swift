//
//  RuleController.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import Foundation

/// Fetch and cache the rules loaded from the server
class RuleController: APIWrapper {
    // MARK: - Singleton
    
    static let shared = RuleController()
    
    // MARK: - Source of truth
    
    /// The list of all the rules
    var allRules: [Rule]?
    
    /// The rules and subsections that have been loaded so far (cached by index to speed up future loads)
    var rulesAndSubsections: [String: Rule]?
    
    // MARK: - CRUD Methods
    
    /// Load all the rules
    func fetchRules(_ completion: @escaping ResultCompletion) {
        
    }
    
    /// Load a specific rule or subsection
    
}

