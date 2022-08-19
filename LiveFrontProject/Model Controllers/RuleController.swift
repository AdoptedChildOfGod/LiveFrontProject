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
    var rulesAndSubsections = [String: Rule]()

    // MARK: - CRUD Methods

    /// Read all the rules
    func fetchRules(_ completion: @escaping ResultCompletion) {
        // Send the API request
        apiRequest(urlComponents: [URLs.rules], errorCompletion: completion) { [weak self] (allRules: AllRules) in
            // Unwrap and cache the data (use an empty array for nil to show an error in the UI)
            self?.allRules = allRules.results ?? []

            // Return the success
            return completion(.success(true))
        }
    }

    /// Read a specific rule or subsection
    func fetchRule(withIndex index: String, andURL url: String, completion: @escaping ResultCompletionWith<Rule?>) {
        // Check the dictionary of cached results first to avoid re-pulling the data
        if let rule = rulesAndSubsections[index] { return completion(.success(rule)) }

        // Send the API request
        apiRequest(urlComponents: [url], errorCompletion: completion) { [weak self] (rule: Rule) in
            // Unwrap and cache the data by index
            self?.rulesAndSubsections[index] = rule

            // Return the success
            return completion(.success(rule))
        }
    }
}
