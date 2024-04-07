//
//  LatiFlexNetworkCell.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkCellInterface: AnyObject {
    func prepareUI()
    func setTitleLabel(text: String?)
    func setHttpMethodLabel(text: String?)
    func setHttpStatusLabel(text: String?)
    func setResponseTimeLabel(text: String?)
    func setTimeIntervalLabel(text: String?)
    func setHttpContainerViewBackgrounColor(color: UIColor?)
}

private extension LatiFlexNetworkCell {
    enum Constant {
        static let httpMethodLabelFontSize: CGFloat = 10
        static let httpStatusLabelFontSize: CGFloat = 10
        static let responseTimeLabelFontSize: CGFloat = 8
        static let timeIntervalLabelFontSize: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 10
        static let titleLabelNumberOfLines: Int = 3
        static let httpContainerViewWidthConstraints: CGFloat = 60
        static let containerStackViewSpacing: CGFloat = 10
        static let separatorViewHeightConstraint: CGFloat = 1
    }
}

final class LatiFlexNetworkCell: UICollectionViewCell {
    var presenter: LatiFlexNetworkCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private var httpContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var httpMethodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.httpMethodLabelFontSize, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var httpStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.httpStatusLabelFontSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var responseTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.responseTimeLabelFontSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var timeIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.timeIntervalLabelFontSize, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Constant.titleLabelFontSize, weight: .medium)
        titleLabel.numberOfLines = Constant.titleLabelNumberOfLines
        
        return titleLabel
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        return separatorView
    }()
}

extension LatiFlexNetworkCell: LatiFlexNetworkCellInterface {
    func prepareUI() {
        let httpStatusStackView = UIStackView(arrangedSubviews: [httpMethodLabel, httpStatusLabel, responseTimeLabel, timeIntervalLabel])
        httpStatusStackView.axis = .vertical
        httpStatusStackView.distribution = .fillEqually
        httpStatusStackView.alignment = .center
        
        httpContainerView.widthAnchor.constraint(equalToConstant: Constant.httpContainerViewWidthConstraints).isActive = true
        httpStatusStackView.embedEdgeToEdge(in: httpContainerView)

        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, separatorView])
        titleStackView.axis = .vertical
        titleStackView.distribution = .fill
        
        let containerStackView = UIStackView(arrangedSubviews: [httpContainerView, titleStackView])
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.embedEdgeToEdge(in: self)
        
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: Constant.separatorViewHeightConstraint).isActive = true
    }
    
    func setTitleLabel(text: String?) {
        titleLabel.text = text
    }

    func setHttpMethodLabel(text: String?) {
        httpMethodLabel.text = text
    }
    
    func setHttpStatusLabel(text: String?) {
        httpStatusLabel.text = text
    }
    
    func setResponseTimeLabel(text: String?) {
        responseTimeLabel.text = text
    }
    
    func setTimeIntervalLabel(text: String?) {
        timeIntervalLabel.text = text
    }
    
    func setHttpContainerViewBackgrounColor(color: UIColor?) {
        httpContainerView.backgroundColor = color
    }
}
