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
    func setDetailLabelVisibility(isHidden: Bool)
}

private extension LatiFlexCell {
    enum Constant {
        static let titleLabelFontSize: CGFloat = 16
        static let detailLabelFontSize: CGFloat = 12
        static let stackViewLeadingConstraint: CGFloat = 10
        static let responseViewFontSize: CGFloat = 12
        static let separatorViewHeight: CGFloat = 0.5
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
    
    private let detailLabel: UITextView = {
        let responseView = UITextView()
        responseView.font = .systemFont(ofSize: Constant.responseViewFontSize)
        return responseView
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        return separatorView
    }()
    
}

extension LatiFlexCell: LatiFlexCellInterface {
    func prepareUI() {
        detailLabel.isEditable = false
        self.layer.cornerRadius = 6
        self.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, separatorView, detailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.embed(in: self,
                        anchors: [.top(.zero),
                                  .leading(Constant.stackViewLeadingConstraint),
                                  .trailing(.zero),
                                  .bottom(.zero)])
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: Constant.separatorViewHeight).isActive = true
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
}
