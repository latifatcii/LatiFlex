//
//  UIView+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit
//
public extension UIView {
//    enum ViewConstant {
//        public static let circularCornersDevider: CGFloat = 2.0
//        public static let visibilityTransitionDuration = 0.25
//    }
//    
//    var hasVisibleSubviews: Bool {
//        subviews.contains { $0.isHidden == false }
//    }
//
//    var allSubviews: [UIView] {
//        subviews.reduce([UIView]()) { $0 + [$1] + $1.allSubviews }
//    }
//
//    func setVisibility(isHidden: Bool,
//                       animated: Bool,
//                       duration: Double = ViewConstant.visibilityTransitionDuration) {
//        guard self.isHidden != isHidden else { return }
//        if animated {
//            UIView.transition(
//                with: self,
//                duration: duration,
//                options: .transitionCrossDissolve,
//                animations: { self.isHidden = isHidden },
//                completion: nil)
//        } else {
//            self.isHidden = isHidden
//        }
//    }
//    
//    /** Loads instance from nib with the same name. */
//    func loadNib(bundle: Bundle) -> UIView {
//        let nibName = type(of: self).description().components(separatedBy: ".").last!
//
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as! UIView
//    }
//    
    @discardableResult
    func embedEdgeToEdge(in view: UIView, shouldEmbedSafeArea: Bool = false) -> [NSLayoutConstraint] {
        return embed(in: view, anchors: [.leading(0, shouldEmbedSafeArea: shouldEmbedSafeArea),
                                         .trailing(0, shouldEmbedSafeArea: shouldEmbedSafeArea),
                                         .top(0, shouldEmbedSafeArea: shouldEmbedSafeArea),
                                         .bottom(0, shouldEmbedSafeArea: shouldEmbedSafeArea)])
    }

    @discardableResult
    func embed(in superView: UIView, anchors: [Anchor], additionalConstraints: [NSLayoutConstraint]? = nil) -> [NSLayoutConstraint] {
        superView.addSubview(self)
        var constraints = additionalConstraints ?? [NSLayoutConstraint]()

        anchors.forEach { anchor in
            switch anchor {
            case .leading(let value, let toView, let shouldEmbedSafeArea):
                if let toView = toView {
                    constraints.append(leadingAnchor.constraint(equalTo: shouldEmbedSafeArea ? toView.safeTrailingAnchor() : toView.trailingAnchor, constant: value))
                } else {
                    constraints.append(leadingAnchor.constraint(equalTo: shouldEmbedSafeArea ? superView.safeLeadingAnchor() : superView.leadingAnchor, constant: value))
                }
            case .trailing(let value, let toView, let shouldEmbedSafeArea):
                if let toView = toView {
                    constraints.append(trailingAnchor.constraint(equalTo: shouldEmbedSafeArea ? toView.safeLeadingAnchor() : toView.leadingAnchor, constant: value))
                } else {
                    constraints.append(trailingAnchor.constraint(equalTo: shouldEmbedSafeArea ? superView.safeTrailingAnchor() : superView.trailingAnchor, constant: value))
                }
            case .top(let value, let toView, let shouldEmbedSafeArea):
                if let toView = toView {
                    constraints.append(topAnchor.constraint(equalTo: shouldEmbedSafeArea ? toView.safeBottomAnchor() : toView.bottomAnchor, constant: value))
                } else {
                    constraints.append(topAnchor.constraint(equalTo: shouldEmbedSafeArea ? superView.safeTopAnchor() : superView.topAnchor, constant: value))
                }
            case .bottom(let value, let toView, let shouldEmbedSafeArea):
                if let toView = toView {
                    constraints.append(bottomAnchor.constraint(equalTo: shouldEmbedSafeArea ? toView.safeTopAnchor() : toView.topAnchor, constant: value))
                } else {
                    constraints.append(bottomAnchor.constraint(equalTo: shouldEmbedSafeArea ? superView.safeBottomAnchor() : superView.bottomAnchor, constant: value))
                }
                constraints.append(bottomAnchor.constraint(equalTo: (toView ?? superView).bottomAnchor, constant: value))
            case .centerY(let value, let toView):
                constraints.append(centerYAnchor.constraint(equalTo: (toView ?? superView).centerYAnchor, constant: value))
            case .centerX(let value, let toView):
                constraints.append(centerXAnchor.constraint(equalTo: (toView ?? superView).centerXAnchor, constant: value))
            case .width(let value):
                constraints.append(widthAnchor.constraint(equalToConstant: value))
            case .height(let value):
                constraints.append(heightAnchor.constraint(equalToConstant: value))
            }
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    func safeTopAnchor() -> NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }

    func safeBottomAnchor() -> NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }

    func safeLeadingAnchor() -> NSLayoutXAxisAnchor {
        if responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }

    func safeTrailingAnchor() -> NSLayoutXAxisAnchor {
        if responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
}

public extension UIView {
    enum Anchor {
        case leading(CGFloat, toView: UIView? = nil, shouldEmbedSafeArea: Bool = false)
        case trailing(CGFloat, toView: UIView? = nil, shouldEmbedSafeArea: Bool = false)
        case top(CGFloat, toView: UIView? = nil, shouldEmbedSafeArea: Bool = false)
        case bottom(CGFloat, toView: UIView? = nil, shouldEmbedSafeArea: Bool = false)
        case centerY(CGFloat, toView: UIView? = nil)
        case centerX(CGFloat, toView: UIView? = nil)
        case width(CGFloat)
        case height(CGFloat)
    }
}
