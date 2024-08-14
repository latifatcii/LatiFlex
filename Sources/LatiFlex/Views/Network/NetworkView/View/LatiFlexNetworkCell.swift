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
    func prepareCopyCurlButtonForDefaultState()
    func prepareCopyCurlButtonForCopiedState()
    func setTextToClipboard(_ text: String?)
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
        static let copiedText = "Copied!"
        static let copyCurlText = "Copy cUrl"
        static let copyButtonInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        static let copyButtonRadius = 8.0
        static let copyButtonPadding = -8.0
        static let copyButtonHeight = 24.0
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
    
    private var curlButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var copyCurlButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.copyCurlText, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = Constant.copyButtonRadius
        button.contentEdgeInsets = Constant.copyButtonInsets
        return button
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

        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, curlButtonContainerView, separatorView])
        titleStackView.spacing = 2
        titleStackView.axis = .vertical
        titleStackView.distribution = .fill
        
        copyCurlButton.embed(in: curlButtonContainerView, anchors: [
            .top(.zero),
            .bottom(.zero),
            .trailing(Constant.copyButtonPadding),
            .height(Constant.copyButtonHeight)
        ])
        copyCurlButton.addTarget(self, action: #selector(copyCurlButtonTapped), for: .touchUpInside)
        
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
    
    @objc private func copyCurlButtonTapped() {
        presenter.copyCurlButtonTapped()
    }
    
    func prepareCopyCurlButtonForDefaultState() {
        copyCurlButton.setTitle(Constant.copyCurlText, for: .normal)
        copyCurlButton.setTitleColor(.orange, for: .normal)
        copyCurlButton.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
    }
    
    func prepareCopyCurlButtonForCopiedState() {
        copyCurlButton.setTitle(Constant.copiedText, for: .normal)
        copyCurlButton.setTitleColor(.systemGreen, for: .normal)
        copyCurlButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
    }
    
    func setTextToClipboard(_ text: String?) {
        UIPasteboard.general.string = text
    }
}
