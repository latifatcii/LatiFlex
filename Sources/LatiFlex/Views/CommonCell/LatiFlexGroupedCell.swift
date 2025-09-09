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
        static let titleLabelFontSize: CGFloat = 16
        static let detailLabelFontSize: CGFloat = 12
        static let countLabelFontSize: CGFloat = 14
        static let stackViewLeadingConstraint: CGFloat = 10
        static let stackViewTrailingConstraint: CGFloat = -10
        static let separatorViewHeight: CGFloat = 1
        static let countBadgeSize: CGFloat = 24
        static let countBadgeTrailingConstraint: CGFloat = -15
        static let expandIconSize: CGFloat = 20
    }
}

final class LatiFlexGroupedCell: UICollectionViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let expandIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.titleLabelFontSize, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.detailLabelFontSize)
        label.textColor = .darkGray
        return label
    }()

    private let countBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = Constant.countBadgeSize / 2
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
        label.textColor = .lightGray
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
        contentView.addSubview(containerView)
        containerView.embedEdgeToEdge(in: contentView)

        // Setup expand icon
        containerView.addSubview(expandIconImageView)
        expandIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.stackViewLeadingConstraint),
            expandIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            expandIconImageView.widthAnchor.constraint(equalToConstant: Constant.expandIconSize),
            expandIconImageView.heightAnchor.constraint(equalToConstant: Constant.expandIconSize)
        ])

        // Setup count badge
        containerView.addSubview(countBadgeView)
        countBadgeView.translatesAutoresizingMaskIntoConstraints = false
        countBadgeView.addSubview(countLabel)
        countLabel.embed(in: countBadgeView, anchors: [.top(4), .leading(8), .bottom(4), .trailing(8)])

        NSLayoutConstraint.activate([
            countBadgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constant.countBadgeTrailingConstraint),
            countBadgeView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            countBadgeView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constant.countBadgeSize)
        ])

        // Setup labels stack
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel, dateRangeLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 2
        labelsStack.distribution = .fill

        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: expandIconImageView.trailingAnchor, constant: 10),
            labelsStack.trailingAnchor.constraint(equalTo: countBadgeView.leadingAnchor, constant: -10),
            labelsStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            labelsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])

        // Setup separator
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.stackViewLeadingConstraint),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constant.separatorViewHeight)
        ])
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

            // Show date range for grouped events
            dateRangeLabel.text = groupedEvent.dateRangeText
            dateRangeLabel.isHidden = groupedEvent.dateRangeText == nil
        } else {
            countBadgeView.isHidden = true
            expandIconImageView.isHidden = true
            dateRangeLabel.isHidden = true
        }

        // Set text color based on success/failure
        detailLabel.textColor = groupedEvent.isSuccess ? .darkGray : .red
    }

    func setExpanded(_ isExpanded: Bool) {
        let imageName = isExpanded ? "chevron.down" : "chevron.right"
        expandIconImageView.image = UIImage(systemName: imageName)
    }
}
