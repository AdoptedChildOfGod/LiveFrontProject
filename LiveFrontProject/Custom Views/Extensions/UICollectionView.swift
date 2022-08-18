//
//  UICollectionView.swift
//
//  Created by Shannon Draeker on 6/7/21.
//

import UIKit.UICollectionView

extension UICollectionView {
    // MARK: - Initializer

    /// A way to initialize a collectionView while setting up the most important properties at the same time
    /// - Parameters:
    ///   - delegate: The delegate for the collectionView (usually "self" of the view controller creating the collectionView)
    ///   - dataSource: The datasource for the tableview (usually "self" of the view controller creating the tableView)
    ///   - cellClass: The class to be used for each colletionView cell
    ///   - spacing: The spacing between the collectionView items (default = 0)
    ///   - itemSize: The size of each cell in the collectionView (optional, default = nil)
    ///   - background: The background color of the collectionView (default = .clear)
    convenience init(delegate: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate,
                     dataSource: UICollectionViewDataSource,
                     cellClass: UICollectionViewCell.Type,
                     spacing: CGFloat = 0,
                     itemSize: CGSize? = nil,
                     background: UIColor = .clear) {
        // Set the spacing
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        if let itemSize = itemSize { layout.itemSize = itemSize }

        // Initialize the collection view with the layout
        self.init(frame: .zero, collectionViewLayout: layout)

        // Configure the settings of the collectionView
        self.delegate = delegate
        self.dataSource = dataSource
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)

        // Set up the display of the collectionView
        backgroundColor = background
    }
}
