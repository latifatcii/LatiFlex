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
    func prepareCopyCurlButtonForDefaultState()
    func prepareCopyCurlButtonForCopiedState()
    func setTextToClipboard(_ text: String?)
    func setStatusImage(symbolName: String?)
    func setContainerStackViewColorToGreen()
    func setContainerStackViewColorToRed()
}

private extension LatiFlexNetworkCell {
    enum Constant {
        static let httpMethodLabelFontSize: CGFloat = 12
        static let httpStatusLabelFontSize: CGFloat = 12
        static let responseTimeLabelFontSize: CGFloat = 12
        static let timeIntervalLabelFontSize: CGFloat = 12
        static let titleLabelFontSize: CGFloat = 11.3
        static let titleLabelNumberOfLines: Int = 2
        static let httpContainerViewWidthConstraints: CGFloat = 60
        static let containerStackViewSpacing: CGFloat = 1.7
        static let separatorViewHeightConstraint: CGFloat = 1
        static let copiedText = "Copied!"
        static let copyCurlText = "Copy cUrl"
        static let copyButtonInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        static let copyButtonRadius = 8.0
        static let copyButtonPadding = -8.0
        static let copyButtonHeight = 24.0
        static let httpStatusStackViewTrailing = 0
        static let customGreen = UIColor(red: 120/255.0, green: 200/255.0, blue: 86/255.0, alpha: 1.0)
        static let customRed = UIColor(red: 1, green: 52/255.0, blue: 58/255.0, alpha: 1.0)

    }
}

final class LatiFlexNetworkCell: UICollectionViewCell {
    var presenter: LatiFlexNetworkCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private var httpStatusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var responseTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
   }()
    
    private var secondEmptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
   }()
   
    private var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var copyCurlButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.orange.withAlphaComponent(0.3).cgColor
        view.backgroundColor = .orange.withAlphaComponent(0.1)
        return view
   }()
    
    private var copyCurlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var imageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var responseTimeImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var timeImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
   }()
    
    private var httpMethodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.httpMethodLabelFontSize, weight: .bold)
        label.textColor = .darkGray.withAlphaComponent(0.65)
        return label
    }()
    
    private var httpStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.httpStatusLabelFontSize, weight: .semibold)
        label.textColor = Constant.customGreen
        return label
    }()
    
    private var responseTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.responseTimeLabelFontSize, weight: .semibold)
        label.textColor = Constant.customGreen
        return label
    }()
    
    private var timeIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.timeIntervalLabelFontSize, weight: .semibold)
        label.textColor = .darkGray.withAlphaComponent(0.65)
        return label
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Constant.titleLabelFontSize, weight: .medium)
        titleLabel.numberOfLines = Constant.titleLabelNumberOfLines
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private var copyCurlButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.copyCurlText, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = Constant.copyButtonRadius
        button.contentEdgeInsets = Constant.copyButtonInsets
        return button
    }()
    
    private var statusImageView: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = Constant.customGreen
        return imageView
    }()
    
    private var timeImage: UIImageView = {
        let image = UIImage(systemName: "gauge.with.needle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = Constant.customGreen
        return imageView
    }()
    
    private var responseTimeImage: UIImageView = {
        let image = UIImage(systemName: "hourglass.bottomhalf.filled")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .darkGray.withAlphaComponent(0.65)
        return imageView
    }()
}

extension LatiFlexNetworkCell: LatiFlexNetworkCellInterface {
    func prepareUI() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .cyan
        
        titleLabel.embed(in: titleView, anchors: [
            .top(.zero),
            .bottom(.zero),
            .trailing(-3),
            .leading(8)
        ])
        
        copyCurlButton.embed(in: copyCurlButtonView, anchors: [
            .top(0),
            .bottom(-2),
            .trailing(0),
            .leading(0)
        ])
        
        copyCurlButtonView.embed(in: copyCurlView, anchors: [
            .top(0),
            .bottom(-2.5),
            .trailing(0),
            .leading(5)
        ])
        
        statusImageView.embed(in: imageView, anchors: [
            .top(2),
            .bottom(-2),
            .trailing(-2),
            .leading(2)
        ])
       
        timeImage.embed(in: timeImageView, anchors: [
            .top(2),
            .bottom(-2),
            .trailing(-2),
            .leading(2)
        ])
        
        responseTimeImage.embed(in: responseTimeImageView, anchors: [
            .top(2),
            .bottom(-2),
            .trailing(-2),
            .leading(2)
        ])
       
        let containerStackView = UIStackView(arrangedSubviews: [imageView, httpStatusLabel, emptyView,timeImageView, responseTimeLabel ])
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.backgroundColor = .white
        containerStackView.layer.cornerRadius = 10
        containerStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        containerStackView.embed(in: responseTimeView, anchors: [
            .top(.zero),
            .bottom(.zero),
            .trailing(-5),
            .leading(5)
        ])
        
        let httpStatusStackView = UIStackView(arrangedSubviews: [httpMethodLabel,responseTimeImageView, timeIntervalLabel,secondEmptyView,copyCurlView ])
        httpStatusStackView.axis = .horizontal
        httpStatusStackView.alignment = .center
        httpStatusStackView.layer.cornerRadius = 10
        httpStatusStackView.backgroundColor = .white
        httpStatusStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        httpMethodLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        responseTimeImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        responseTimeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeIntervalLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        copyCurlView.widthAnchor.constraint(equalToConstant: 95).isActive = true
        httpStatusStackView.embed(in: httpStatusView, anchors: [
            .top(.zero),
            .bottom(.zero),
            .trailing(-10),
            .leading(8)
        ])

        let mainStackView = UIStackView(arrangedSubviews: [responseTimeView,titleView, httpStatusView])
        mainStackView.spacing = 2
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.embedEdgeToEdge(in: self)
        mainStackView.backgroundColor = .white
        mainStackView.layer.cornerRadius = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        responseTimeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        httpStatusView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        copyCurlButton.addTarget(self, action: #selector(copyCurlButtonTapped), for: .touchUpInside)
        
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
    
    func setContainerStackViewColorToGreen() {
        statusImageView.tintColor = Constant.customGreen
        responseTimeLabel.textColor = Constant.customGreen
        timeImage.tintColor = Constant.customGreen
        httpStatusLabel.textColor = Constant.customGreen
    }
    
    func setContainerStackViewColorToRed() {
        statusImageView.tintColor = Constant.customRed
        responseTimeLabel.textColor = Constant.customRed
        timeImage.tintColor = Constant.customRed
        httpStatusLabel.textColor = Constant.customRed
    }
    
    func setStatusImage(symbolName: String?) {
        statusImageView.image = UIImage(systemName: symbolName ?? "")
    }
}
