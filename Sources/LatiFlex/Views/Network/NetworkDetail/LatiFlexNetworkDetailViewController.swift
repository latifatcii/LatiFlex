//
//  LatiFlexNetworkDetailViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkDetailViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    func prepareUI()
    func setToPasteboard(_ text: String)
}

private extension LatiFlexNetworkDetailViewController {
    enum Constant {
        static let responseViewFontSize: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 9
        static let textOfHeightFontSize: CGFloat = 12
        static let heightPadding: CGFloat = 40
    }
}

final class LatiFlexNetworkDetailViewController: UIViewController {
    var presenter: LatiFlexNetworkDetailPresenterInterface!
    
    private let responseView: UITextView = {
        let responseView = UITextView()
        responseView.font = .systemFont(ofSize: Constant.responseViewFontSize)
        responseView.textColor = .orange
        return responseView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LatiFlexNetworkDetailCell.self, forCellWithReuseIdentifier: "LatiFlexNetworkDetailCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexNetworkDetailViewController: LatiFlexNetworkDetailViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    func prepareUI() {
        view.backgroundColor = .systemGray5
        collectionView.backgroundColor = .systemGray5
        collectionView.embedEdgeToEdge(in: view)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setToPasteboard(_ text: String) { UIPasteboard.general.string = text }
}

extension LatiFlexNetworkDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexNetworkDetailCell", for: indexPath) as? LatiFlexNetworkDetailCell else { return UICollectionViewCell() }

        let cellPresenter = LatiFlexNetworkDetailCellPresenter(view: cell,
                                                  title: presenter.keyAt(index: indexPath.item),
                                                  detail: presenter.valueAt(index: indexPath.item))
        cell.presenter = cellPresenter
        return cell
    }
    

}

extension LatiFlexNetworkDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textHeight = presenter.valueAt(index: indexPath.item)?.heightOfText(withConstrainedWidth: collectionView.frame.width,
                                                                                font: .systemFont(ofSize: Constant.textOfHeightFontSize)) ?? .zero
        return .init(width: collectionView.frame.width - 16, height: textHeight + Constant.heightPadding)
    }
}

private extension String {
    func heightOfText(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        // swiftformat:disable redundantSelf
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
