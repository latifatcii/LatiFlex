//
//  LatiFlexCell.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexCellInterface: AnyObject {
    func prepareUI()
    func setTitleLabel(text: String?)
    func setDetailLabel(text: String?)
    func setDetailLabelTextColor(_ color: UIColor)
    func setDetailLabelVisibility(isHidden: Bool)
}

private extension LatiFlexCell {
    enum Constant {
        static let titleLabelFontSize: CGFloat = 16
        static let detailLabelFontSize: CGFloat = 13
        static let stackViewLeadingConstraint: CGFloat = 20
        static let stackViewTrailingConstraint: CGFloat = -20
        static let separatorViewHeight: CGFloat = 0.5
        static let verticalPadding: CGFloat = 12
    }
}

final class LatiFlexCell: UICollectionViewCell {
    var presenter: LatiFlexCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }

    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Constant.titleLabelFontSize)

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return titleLabel
    }()

    private var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: Constant.detailLabelFontSize)
        detailLabel.numberOfLines = .zero
        detailLabel.textColor = .black
        return detailLabel
    }()

    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray

        return separatorView
    }()
}

extension LatiFlexCell: LatiFlexCellInterface {
    func prepareUI() {
        contentView.backgroundColor = .systemBackground
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 3
        labelStackView.distribution = .fill
        
        contentView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.verticalPadding),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.stackViewLeadingConstraint),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constant.stackViewTrailingConstraint),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.verticalPadding)
        ])
        
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.stackViewLeadingConstraint),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constant.separatorViewHeight)
        ])
    }

    func setTitleLabel(text: String?) {
        titleLabel.text = text
    }

    func setDetailLabel(text: String?) {
        detailLabel.text = text
    }

    func setDetailLabelVisibility(isHidden: Bool) {
        detailLabel.isHidden = isHidden
    }

    func setDetailLabelTextColor(_ color: UIColor) {
        detailLabel.textColor = color
    }
}
