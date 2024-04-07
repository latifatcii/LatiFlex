//
//  LatiFlexDeeplinkDetailViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexDeeplinkDetailViewInterface: AnyObject {
    var deeplinkText: String? { get }
    
    func prepareUI()
    func setTextField(text: String?)
    func endEditing()
}

private extension LatiFlexDeeplinkDetailViewController {
    enum Constant {
        static let minimumLineSpacing: CGFloat = 10
        static let stackViewBorderWidth: CGFloat = 0.3
        static let stackViewHeightConstraint: CGFloat = 100
        static let cellHeight: CGFloat = 50

        enum TextField {
            static let leftViewWidth: CGFloat = 10
            static let leftViewHeight: CGFloat = 40
            static let placeHolder: String = "ty://?Channel=International&Page=Account"
            static let borderWidth: CGFloat = 0.2
            static let fontSize: CGFloat = 12
        }
        
        enum RouteButton {
            static let topConstraint: CGFloat = 10
            static let bottomConstraint: CGFloat = -10
            static let width: CGFloat = 150
            static let title: String = "Route"
            static let radius: CGFloat = 10
        }
    }
}

final class LatiFlexDeeplinkDetailViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LatiFlexCell.self, forCellWithReuseIdentifier: "LatiFlexCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: Constant.TextField.leftViewWidth,
                                                  height: Constant.TextField.leftViewHeight))
        textField.leftViewMode = .always
        textField.placeholder = Constant.TextField.placeHolder
        textField.layer.borderWidth = Constant.TextField.borderWidth
        textField.font = .systemFont(ofSize: Constant.TextField.fontSize)
        return textField
    }()
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
        
    private let routeButton: UIButton = {
        let routeButton = UIButton()
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.setTitle(Constant.RouteButton.title, for: .normal)
        routeButton.backgroundColor = .orange
        routeButton.layer.cornerRadius = Constant.RouteButton.radius
        return routeButton
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layer.borderWidth = Constant.stackViewBorderWidth

        return stackView
    }()
    
    @objc private func routeButtonTapped() {
        presenter.routeButtonTapped()
    }
    
    var presenter: LatiFlexDeeplinkDetailPresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexDeeplinkDetailViewController: LatiFlexDeeplinkDetailViewInterface {
    var deeplinkText: String? {
        textField.text
    }
    
    func prepareUI() {
        view.backgroundColor = .white
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        routeButton.embed(in: containerView, anchors: [.top(Constant.RouteButton.topConstraint),
                                                       .bottom(Constant.RouteButton.bottomConstraint),
                                                       .centerX(.zero, toView: containerView),
                                                       .width(Constant.RouteButton.width)])
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(containerView)
        
        stackView.embed(in: view, anchors: [.leading(.zero),
                                            .trailing(.zero),
                                            .top(.zero,
                                                 shouldEmbedSafeArea: true),
                                            .height(Constant.stackViewHeightConstraint)])
        
        collectionView.embed(in: view, anchors: [.leading(.zero),
                                                 .trailing(.zero),
                                                 .top(.zero,
                                                      toView: stackView),
                                                 .bottom(.zero,
                                                         shouldEmbedSafeArea: true)])
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setTextField(text: String?) {
        textField.text = text
    }
    
    func endEditing() {
        view.endEditing(true)
    }
}

extension LatiFlexDeeplinkDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatiFlexCell", for: indexPath) as? LatiFlexCell else { return UICollectionViewCell() }
        let cellPresenter = LatiFlexCellPresenter(view: cell,
                                                  title: presenter.itemAt(index: indexPath.item)?.name,
                                                  detail: presenter.itemAt(index: indexPath.item)?.deeplink)
        cell.presenter = cellPresenter
        return cell
    }
}

extension LatiFlexDeeplinkDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: Constant.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(index: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.scrollViewDidScroll()
    }
}
