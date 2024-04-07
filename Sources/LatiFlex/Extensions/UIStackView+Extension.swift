//
//  UIStackView+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

//import UIKit
//
//public extension UIStackView {
//    func removeArrangedSubview(_ index: Int) {
//        arrangedSubviews[index].removeFromSuperview()
//    }
//
//    func replaceItem(at index: Int, with view: UIView) {
//        removeArrangedSubview(index)
//        insertArrangedSubview(view, at: index)
//    }
//    
//    func hasArrangedSubview(_ view: UIView) -> Bool {
//        for arrangedSubview in arrangedSubviews where arrangedSubview == view {
//            return true
//        }
//        return false
//    }
//
//    func insertArrangedSubview(_ view: UIView, above: UIView) {
//        for (index, arrangedSubview) in arrangedSubviews.enumerated() where arrangedSubview == above {
//            if hasArrangedSubview(view), let previoustIndex = subviews.firstIndex(of: view), previoustIndex < index {
//                insertArrangedSubview(view, at: index - 1)
//            } else {
//                insertArrangedSubview(view, at: index)
//            }
//        }
//    }
//
//    func insertArrangedSubview(_ view: UIView, below: UIView) {
//        for (index, arrangedSubview) in arrangedSubviews.enumerated() where arrangedSubview == below {
//            insertArrangedSubview(view, at: index + 1)
//        }
//    }
//
//    func addArrangedSubviews(_ views: [UIView]) {
//        for view in views {
//            addArrangedSubview(view)
//        }
//    }
//
//    func removeAllArrangedViews() {
//        guard !arrangedSubviews.isEmpty else { return }
//        for view in arrangedSubviews {
//            view.removeFromSuperview()
//        }
//    }
//
//    func removeLastArrangedSubview() {
//        guard !arrangedSubviews.isEmpty else { return }
//        let view = arrangedSubviews.last
//        view?.removeFromSuperview()
//    }
//
//    func removeLastItems(_ count: Int) {
//        guard !arrangedSubviews.isEmpty else { return }
//        for view in arrangedSubviews.suffix(count) {
//            view.removeFromSuperview()
//        }
//    }
//
//    func containsElement<T>(ofType type: T.Type) -> Bool where T: UIView {
//        return arrangedSubviews.contains { $0.className == type.className}
//    }
//
//    func removeAllViews<T>(ofType type: T.Type) where T: UIView {
//        arrangedSubviews.forEach({ ($0 as? T)?.removeFromSuperview() })
//    }
//}
//
