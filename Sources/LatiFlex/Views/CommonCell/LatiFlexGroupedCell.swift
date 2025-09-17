//
//  LatiFlexGroupedCell.swift
//  LatiFlex
//
//  Created by Claude on 2025-09-06.
//  Copyright © 2025 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexGroupedCellInterface: AnyObject {
    func prepareUI()
    func configure(with groupedEvent: GroupedEvent)
    func setExpanded(_ isExpanded: Bool)
}

private extension LatiFlexGroupedCell {
    enum Constant {
        static let titleLabelFontSize: CGFloat = 15
        static let detailLabelFontSize: CGFloat = 12
        static let countLabelFontSize: CGFloat = 13
        static let stackViewLeadingConstraint: CGFloat = 12
        static let stackViewTrailingConstraint: CGFloat = -14
        static let separatorViewHeight: CGFloat = 0.5
        static let countBadgeHeight: CGFloat = 24
        static let countBadgeWidth: CGFloat = 32 // Reduced width to give more space for text
        static let countBadgeTrailingConstraint: CGFloat = -14
        static let expandIconSize: CGFloat = 18
        static let cornerRadius: CGFloat = 10
        static let verticalPadding: CGFloat = 10
    }
}

final class LatiFlexGroupedCell: UICollectionViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Constant.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private let expandIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.titleLabelFontSize, weight: .medium)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.detailLabelFontSize)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let countBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        view.layer.cornerRadius = Constant.countBadgeHeight / 2
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.countLabelFontSize, weight: .semibold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()

    private let dateRangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.detailLabelFontSize - 1)
        label.textColor = .tertiaryLabel
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 1
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])

        // Setup expand icon
        containerView.addSubview(expandIconImageView)
        expandIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.stackViewLeadingConstraint),
            expandIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            expandIconImageView.widthAnchor.constraint(equalToConstant: Constant.expandIconSize),
            expandIconImageView.heightAnchor.constraint(equalToConstant: Constant.expandIconSize)
        ])

        // Setup count badge at trailing edge inside container
        containerView.addSubview(countBadgeView)
        countBadgeView.translatesAutoresizingMaskIntoConstraints = false
        countBadgeView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: countBadgeView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countBadgeView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            countBadgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            countBadgeView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
            countBadgeView.heightAnchor.constraint(equalToConstant: Constant.countBadgeHeight),
            countBadgeView.widthAnchor.constraint(equalToConstant: Constant.countBadgeWidth)
        ])

        // Setup labels without date range initially
        let mainLabelsStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        mainLabelsStack.axis = .vertical
        mainLabelsStack.spacing = 0
        mainLabelsStack.distribution = .fill
        mainLabelsStack.alignment = .fill

        containerView.addSubview(mainLabelsStack)
        mainLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabelsStack.leadingAnchor.constraint(equalTo: expandIconImageView.trailingAnchor, constant: 8),
            mainLabelsStack.trailingAnchor.constraint(equalTo: countBadgeView.leadingAnchor, constant: -8),
            mainLabelsStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            mainLabelsStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
        
        // Add date range label separately, below the main stack
        containerView.addSubview(dateRangeLabel)
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateRangeLabel.leadingAnchor.constraint(equalTo: mainLabelsStack.leadingAnchor),
            dateRangeLabel.trailingAnchor.constraint(equalTo: countBadgeView.leadingAnchor, constant: -8),
            dateRangeLabel.topAnchor.constraint(equalTo: mainLabelsStack.bottomAnchor, constant: 1)
        ])

        // No separator needed for card-style design
    }
}

extension LatiFlexGroupedCell: LatiFlexGroupedCellInterface {
    func prepareUI() {
        // Already prepared in init
    }

    func configure(with groupedEvent: GroupedEvent) {
        titleLabel.text = groupedEvent.title
        detailLabel.text = groupedEvent.subtitle
        detailLabel.isHidden = groupedEvent.subtitle?.isEmpty ?? true

        // Configure count
        if groupedEvent.count > 1 {
            countBadgeView.isHidden = false
            countLabel.text = "\(groupedEvent.count)"
            expandIconImageView.isHidden = false
            setExpanded(groupedEvent.isExpanded)

            // Show date range for grouped events if expanded
            if groupedEvent.isExpanded {
                dateRangeLabel.text = groupedEvent.dateRangeText
                dateRangeLabel.isHidden = false
            } else {
                dateRangeLabel.isHidden = true
            }
        } else {
            countBadgeView.isHidden = true
            expandIconImageView.isHidden = true
            dateRangeLabel.isHidden = true
        }

        // Set text color based on success/failure
        detailLabel.textColor = groupedEvent.isSuccess ? .secondaryLabel : .systemRed
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.containerView.backgroundColor = self.isHighlighted ? .systemGray5 : .systemGray6
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }

    func setExpanded(_ isExpanded: Bool) {
        let imageName = isExpanded ? "chevron.down" : "chevron.right"
        expandIconImageView.image = UIImage(systemName: imageName)
    }
}
