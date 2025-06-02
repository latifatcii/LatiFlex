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
        static let minimumLineSpacing: CGFloat = 9
        static let cellHeight: CGFloat = 80
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
    
    private let enableMockSwitch: UISwitch = {
        let enableSwitch = UISwitch()
        enableSwitch.isOn = LatiFlexNetworkInterceptor.shared.isMockingEnabled()
        return enableSwitch
    }()
    
    private let enableMockLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Mock"
        label.font = UIFont.systemFont(ofSize: 14)
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    private lazy var enableMockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), enableMockLabel, enableMockSwitch, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexNetworkViewController: LatiFlexNetworkViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    func prepareUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag

        navigationItem.titleView = searchBar

        enableMockSwitch.addTarget(self, action: #selector(enableMockSwitchChanged(_:)), for: .valueChanged)

        let verticalStackView = UIStackView(arrangedSubviews: [enableMockStackView, collectionView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        .init(width: view.frame.width - 16, height: Constant.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 2, left: 8, bottom: 2, right: 8)
    }
}

extension LatiFlexNetworkViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSerachButtonClicked(searchtext: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.clearbutton(searchText: searchText)
    }
}

extension LatiFlexNetworkViewController {
    @objc private func enableMockSwitchChanged(_ sender: UISwitch) {
        LatiFlexNetworkInterceptor.shared.setMockEnabled(sender.isOn)
    }
}
