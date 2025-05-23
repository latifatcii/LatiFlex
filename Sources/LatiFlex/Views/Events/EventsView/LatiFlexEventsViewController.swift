//
//  LatiFlexEventsViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexEventsViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    func prepareUI()
    func reloadData()
    func prepareSegmentedControl(items: [String])
    func prepareEventListView()
    func setSearchBarText(text: String)
    func setSummarizeStackViewVisibility(isHidden: Bool)
}

private extension LatiFlexEventsViewController {
    enum Constant {
        static let minimumLineSpacing: CGFloat = 10
        static let collectionViewTopConstraint: CGFloat = 10
        static let cellHeight: CGFloat = 50
    }
}

final class LatiFlexEventsViewController: UIViewController {

    var presenter: LatiFlexEventsPresenterInterface!

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LatiFlexCell.self, forCellWithReuseIdentifier: "LatiFlexCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let summarizeSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchClicked), for: .touchUpInside)
        return switchView
    }()
    
    private let summarizeLabel: UILabel = {
        let summarizeLabel = UILabel()
        summarizeLabel.text = "Summarize Events"
        summarizeLabel.baselineAdjustment = .alignCenters
        return summarizeLabel
    }()
    
    private var stackView: UIStackView?
    private var segmentedControl: UISegmentedControl?

    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @objc private func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        presenter.selectedSegmentChanged(index: segmentedControl.selectedSegmentIndex)
    }
    
    @objc private func switchClicked() {
        presenter.summarizeSwitchChanged(isOn: summarizeSwitch.isOn)
    }
}

extension LatiFlexEventsViewController: LatiFlexEventsViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }

    func prepareUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        collectionView.keyboardDismissMode = .onDrag
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func setSearchBarText(text: String) {
        searchBar.text = text
    }
    
    func setSummarizeStackViewVisibility(isHidden: Bool) {
        stackView?.isHidden = isHidden
    }

    func prepareSegmentedControl(items: [String]) {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.embed(in: view,
                               anchors: [.top(.zero,
                                              shouldEmbedSafeArea: true),
                                         .leading(.zero,
                                                  shouldEmbedSafeArea: true),
                                         .trailing(.zero,
                                                   shouldEmbedSafeArea: true)])
        self.segmentedControl = segmentedControl
    }
    
    func prepareEventListView() {
        summarizeSwitch.isOn = presenter.isSummarizeSwitchEnabled
        
        let stackView = UIStackView(arrangedSubviews: [UIView(),summarizeLabel, summarizeSwitch, UIView()])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        self.stackView = stackView
        
        let verticalStackView = UIStackView(arrangedSubviews: [stackView, collectionView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.embed(in: view,
                                anchors: [.top(Constant.collectionViewTopConstraint,
                                               toView: segmentedControl),
                                          .leading(.zero,
                                                   shouldEmbedSafeArea: true),
                                          .trailing(.zero,
                                                    shouldEmbedSafeArea: true),
                                          .bottom(.zero, shouldEmbedSafeArea: true)])
    }
}

extension LatiFlexEventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexCell", for: indexPath) as? LatiFlexCell else { return UICollectionViewCell() }
        let cellPresenter = LatiFlexCellPresenter(view: cell,
                                                  arguments: presenter.arguments(at: indexPath.item))
        cell.presenter = cellPresenter
        return cell
    }
}

extension LatiFlexEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: Constant.cellHeight)
    }
}

extension LatiFlexEventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
}
