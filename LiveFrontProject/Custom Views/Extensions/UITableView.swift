//
//  UITableView.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UITableView

extension UITableView {
    // MARK: - Initializer

    /// A way to initialize a tableview while setting up the most important properties at the same time
    /// - Parameters:
    ///   - delegate: The delegate for the tableView (usually "self" of the view controller creating the tableView)
    ///   - dataSource: The datasource for the tableview (usually "self" of the view controller creating the tableView)
    ///   - cellClass: The cell class to be used for the cell
    ///   - background: The background color for the tableView (default = .clear)
    ///   - separator: The separator to use between the cells (default = .none)
    convenience init(delegate: UITableViewDelegate,
                     dataSource: UITableViewDataSource,
                     cellClass: UITableViewCell.Type,
                     background: UIColor = .clear,
                     separator: UITableViewCell.SeparatorStyle = .none) {
        self.init()

        // Configure the settings of the tableview
        self.delegate = delegate
        self.dataSource = dataSource
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension

        // Configure the display of the tableview
        backgroundColor = background
        separatorStyle = separator
        tableFooterView = UIView()
        tableHeaderView = UIView()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    // MARK: - Helper Methods

    /// Reload the tableview so that it will automatically set the height of each row
    func resize() {
        // Auto resize the table view with dynamic row heights
        reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        layoutSubviews()
        reloadData()
    }

    /// Reload the data then run a completion after
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: reloadData) { _ in completion() }
    }
}
