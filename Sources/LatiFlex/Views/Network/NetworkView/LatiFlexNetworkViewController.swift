//
//  LatiFlexNetworkViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    func prepareUI()
    func reloadData()
}

private extension LatiFlexNetworkViewController {
    enum Constant {
        static let minimumLineSpacing: CGFloat = 10
        static let cellHeight: CGFloat = 50
    }
}

final class LatiFlexNetworkViewController: UIViewController {
    
    var presenter: LatiFlexNetworkPresenterInterface!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LatiFlexNetworkCell.self, forCellWithReuseIdentifier: "LatiFlexNetworkCell")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexNetworkViewController: LatiFlexNetworkViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    func prepareUI() {
        collectionView.embedEdgeToEdge(in: view)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension LatiFlexNetworkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexNetworkCell", for: indexPath) as? LatiFlexNetworkCell else { return UICollectionViewCell() }

        let cellPresenter = LatiFlexNetworkCellPresenter(view: cell, argument: presenter.argumentAt(index: indexPath.item))
        cell.presenter = cellPresenter
        return cell
    }
}

extension LatiFlexNetworkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: Constant.cellHeight)
    }
}

extension LatiFlexNetworkViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
}
