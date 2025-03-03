//
//  LatiFlexDeeplinkViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexDeeplinkViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    func prepareUI()
}

private extension LatiFlexDeeplinkViewController {
    enum Constant {
        static let minimumLineSpacing: CGFloat = 10
        static let cellHeight: CGFloat = 50
    }
}

final class LatiFlexDeeplinkViewController: UIViewController {
    
    var presenter: LatiFlexDeeplinkPresenterInterface!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LatiFlexCell.self, forCellWithReuseIdentifier: "LatiFlexCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexDeeplinkViewController: LatiFlexDeeplinkViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    func prepareUI() {
        collectionView.embedEdgeToEdge(in: view)
        collectionView.delegate = self
        collectionView.dataSource = self
        title = "Deeplink"
    }
}

extension LatiFlexDeeplinkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexCell", for: indexPath) as? LatiFlexCell else { return UICollectionViewCell() }
        let cellPresenter = LatiFlexCellPresenter(view: cell,
                                                  arguments: presenter.arguments(for: indexPath.row))
        cell.presenter = cellPresenter
        return cell
    }
}

extension LatiFlexDeeplinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: Constant.cellHeight)
    }
}
