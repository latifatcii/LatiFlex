//
//  File.swift
//  
//
//  Created by Latif Atçı on 25.05.2022.
//

import UIKit

private enum LAFloatyViewState {
    case leftOpen
    case leftClosed
    case rightOpen
    case rightClosed
    
    var isOpen: Bool {
        self == .leftOpen || self == .rightOpen
    }
}

private extension LAFloaty {
    enum Constants {
        enum PanHandlerConstants {
            static let centerXPaddingForLeftSide: CGFloat = 5
            static let centerXPaddingForRightSide: CGFloat = 55
        }
        
        enum AnimateItemsConstants {
            static let animationDuration: CGFloat = 0.5
            static let usingSpringWithDamping: CGFloat = 1
            static let initialSpringVelocity: CGFloat = 1
            static let itemYPadding: Int = 55
        }
        
        enum PrepareUIConstants {
            static let initialItemCenterXPadding: CGFloat = 55
            static let initialItemCenterYPadding: CGFloat = 150
            static let otherItemsPadding: Int = 55
        }
        
        enum OpenCloseAnimationConstants {
            static let animationDuration: CGFloat = 0.3
            static let usingSpringWithDamping: CGFloat = 0.55
            static let initialSpringVelocity: CGFloat = 0.3
            static let alpha: CGFloat = 1
            static let delay: CGFloat = 0.1
        }
    }
}

public final class LAFloaty: UIView {
    private var items: [UIButton] = []
    private let initialItem = UIButton()
    public weak var datasource: LAFloatyViewDatasource? {
        didSet {
            prepareUI()
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self { return nil }
        return view
    }
    
    private var state: LAFloatyViewState = .rightClosed
    
    @objc private func panHandler(gesture: UIPanGestureRecognizer) {
        guard !state.isOpen else { return }
        items.forEach { $0.isHidden = true }
        let location = gesture.location(in: self)
        initialItem.center = location
        
        if gesture.state == .ended {
            if initialItem.frame.midX >= self.layer.frame.width / 2 {
                animateItems(firstButtonX: frame.maxX - Constants.PanHandlerConstants.centerXPaddingForRightSide, itemsX: Constants.PanHandlerConstants.centerXPaddingForRightSide, state: .rightClosed)
            } else {
            animateItems(firstButtonX: frame.minX + Constants.PanHandlerConstants.centerXPaddingForLeftSide, itemsX: -Constants.PanHandlerConstants.centerXPaddingForRightSide, state: .leftClosed)
            }
        }
    }
    
    private func animateItems(firstButtonX: CGFloat, itemsX: CGFloat, state: LAFloatyViewState) {
        UIView.animate(withDuration: Constants.AnimateItemsConstants.animationDuration, delay: 0, usingSpringWithDamping: Constants.AnimateItemsConstants.usingSpringWithDamping, initialSpringVelocity: Constants.AnimateItemsConstants.initialSpringVelocity, options: .curveEaseIn, animations: {
            self.initialItem.frame.origin.x = firstButtonX
            guard let dataSource = self.datasource else { return }
            for i in 1...dataSource.itemCount {
                let itemY = CGFloat((i) * Constants.AnimateItemsConstants.itemYPadding)
                self.items[i-1].center.x = self.initialItem.center.x + itemsX
                self.items[i-1].center.y = self.initialItem.center.y - itemY
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.state = state
            self.items.forEach { $0.isHidden = false }
        })
    }
    
    private func prepareUI() {
        guard let datasource = datasource else {
            return
        }
        backgroundColor = .clear
        addSubview(initialItem)
        initialItem.frame = .init(x: frame.maxX - Constants.PrepareUIConstants.initialItemCenterXPadding, y: frame.maxY - Constants.PrepareUIConstants.initialItemCenterYPadding, width: datasource.itemSize.width, height: datasource.itemSize.height)
        initialItem.layer.cornerRadius = datasource.itemCornerRadius
        initialItem.backgroundColor = .white
        initialItem.layer.shadowOpacity = 1
        initialItem.setImage(datasource.itemImage(at: 0), for: .normal)
        initialItem.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        initialItem.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler)))
        
        
        for i in 1...datasource.itemCount {
            let itemY = CGFloat((i) * Constants.PrepareUIConstants.otherItemsPadding)
            let item = UIButton(frame: .init(x: initialItem.frame.origin.x + CGFloat(Constants.PrepareUIConstants.otherItemsPadding), y: initialItem.frame.origin.y - itemY, width: datasource.itemSize.width, height: datasource.itemSize.height))
            item.layer.cornerRadius = datasource.itemCornerRadius
            item.setImage(datasource.itemImage(at: i), for: .normal)
            item.addTarget(self, action: #selector(itemTapped(sender:)), for: .touchUpInside)
            item.tag = i
            item.backgroundColor = .white
            item.layer.shadowOpacity = 1
            item.alpha = 0
            addSubview(item)
            items.append(item)
        }
    }
    
    @objc private func itemTapped(sender: UIButton) {
        datasource?.didSelectItem(at: sender.tag)
        firstButtonTapped()
    }
    
    @objc private func firstButtonTapped() {
        switch state {
        case .leftOpen:
            close(x: -55)
            state = .leftClosed
        case .leftClosed:
            open()
            state = .leftOpen
        case .rightOpen:
            close()
            state = .rightClosed
        case .rightClosed:
            open()
            state = .rightOpen
        }
    }
    
    private func open() {
        var delay = 0.0
        for item in items {
            UIView.animate(withDuration: Constants.OpenCloseAnimationConstants.animationDuration, delay: delay, usingSpringWithDamping: Constants.OpenCloseAnimationConstants.usingSpringWithDamping, initialSpringVelocity: Constants.OpenCloseAnimationConstants.initialSpringVelocity, options: .transitionFlipFromRight) {
                item.alpha = Constants.OpenCloseAnimationConstants.alpha
                item.frame.origin.x = self.initialItem.frame.origin.x
            }
            
            delay += Constants.OpenCloseAnimationConstants.delay
        }
    }
    
    private func close(x: CGFloat = 55) {
        var delay = 0.0
        for item in items.reversed() {
            UIView.animate(withDuration: Constants.OpenCloseAnimationConstants.animationDuration, delay: delay, usingSpringWithDamping: Constants.OpenCloseAnimationConstants.usingSpringWithDamping, initialSpringVelocity: Constants.OpenCloseAnimationConstants.initialSpringVelocity, options: .transitionFlipFromRight) {
                item.alpha = Constants.OpenCloseAnimationConstants.alpha
                item.frame.origin.x = self.initialItem.frame.origin.x + x
            }
            delay += Constants.OpenCloseAnimationConstants.delay
        }
    }
}
