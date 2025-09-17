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
    func setExpandCollapseButtonsVisibility(isHidden: Bool)
}

private extension LatiFlexEventsViewController {
    enum Constant {
        static let minimumLineSpacing: CGFloat = 6
        static let collectionViewTopConstraint: CGFloat = 12
        static let cellHeight: CGFloat = 52
        static let groupedCellHeight: CGFloat = 56
    }
}

final class LatiFlexEventsViewController: UIViewController {

    var presenter: LatiFlexEventsPresenterInterface!

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(LatiFlexCell.self, forCellWithReuseIdentifier: "LatiFlexCell")
        collectionView.register(LatiFlexGroupedCell.self, forCellWithReuseIdentifier: "LatiFlexGroupedCell")
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return collectionView
    }()
    
    private let summarizeSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchClicked), for: .valueChanged)
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
    private var expandCollapseStackView: UIStackView?

    private let searchBar = UISearchBar()
    
    private let expandAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Expand All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return button
    }()
    
    private let collapseAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Collapse All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return button
    }()

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
    
    @objc private func expandAllTapped() {
        presenter.expandAll()
    }
    
    @objc private func collapseAllTapped() {
        presenter.collapseAll()
    }
}

extension LatiFlexEventsViewController: LatiFlexEventsViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }

    func prepareUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .systemGroupedBackground
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        collectionView.keyboardDismissMode = .onDrag
        
        // Add button targets
        expandAllButton.addTarget(self, action: #selector(expandAllTapped), for: .touchUpInside)
        collapseAllButton.addTarget(self, action: #selector(collapseAllTapped), for: .touchUpInside)
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
    
    func setExpandCollapseButtonsVisibility(isHidden: Bool) {
        expandCollapseStackView?.isHidden = isHidden
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
        
        // Add expand/collapse buttons stack
        let expandCollapseStackView = UIStackView(arrangedSubviews: [UIView(), expandAllButton, collapseAllButton, UIView()])
        expandCollapseStackView.axis = .horizontal
        expandCollapseStackView.distribution = .fill
        expandCollapseStackView.spacing = 12
        self.expandCollapseStackView = expandCollapseStackView
        
        let verticalStackView = UIStackView(arrangedSubviews: [stackView, expandCollapseStackView, collectionView])
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
        // Check if we should show grouped cell
        if presenter.shouldShowGrouped() && presenter.isGroupHeader(at: indexPath.item) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexGroupedCell", for: indexPath) as? LatiFlexGroupedCell else { return UICollectionViewCell() }
            if let group = presenter.groupedEventForIndex(indexPath.item) {
                cell.configure(with: group)
            }
            return cell
        }
        
        // Regular cell
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
        let height: CGFloat = presenter.shouldShowGrouped() && presenter.isGroupHeader(at: indexPath.item) ? Constant.groupedCellHeight : Constant.cellHeight
        return .init(width: view.frame.width, height: height)
    }
}

extension LatiFlexEventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
}
