//
//  BaseViewController.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

//import UIKit
//
//open class BaseViewController: UIViewController {
//
//    static var isSwipeBacking: Bool = false
//
//    open var preferredNavigationBarType: NavigationBarType {
//        .native
//    }
//    
//    open var preferredTabBarVisibility: TabBarVisibility {
//        .visible
//    }
//    open var isMultipleGestureEnable: Bool { false }
//
//    open var handleSwipeBackingNavigationBar: Bool {
//        false
//    }
//
//    open var shouldAnimateNavigationBar: Bool { false }
//
//    open override var hidesBottomBarWhenPushed: Bool {
//        get {
//            switch preferredTabBarVisibility {
//            case .hidden:
//                return navigationController?.topViewController == self
//            case .visible:
//                return false
//            case .none:
//                return super.hidesBottomBarWhenPushed
//            }
//        }
//        set {
//            super.hidesBottomBarWhenPushed = newValue
//        }
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleInteractivePopGesture))
//    }
//    
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        guard handleSwipeBackingNavigationBar else {
//            prepareNavBarVisibility()
//            return
//        }
//        guard !BaseViewController.isSwipeBacking else { return }
//        prepareNavBarVisibility()
//    }
//
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        guard BaseViewController.isSwipeBacking, handleSwipeBackingNavigationBar else { return }
//        BaseViewController.isSwipeBacking = false
//        prepareNavBarVisibility()
//    }
//
//    private func prepareNavBarVisibility() {
//        switch preferredNavigationBarType {
//        case .none:
//            navigationController?.setNavigationBarHidden(true, animated: shouldAnimateNavigationBar)
//        case .native:
//            navigationController?.setNavigationBarHidden(false, animated: shouldAnimateNavigationBar)
//        case .notDetermined:
//            break
//        }
//    }
//
//    @objc
//    func handleInteractivePopGesture(gestureRecognizer: UIGestureRecognizer) {
//        guard gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) else{ return }
//        switch gestureRecognizer.state {
//        case .began:
//            BaseViewController.isSwipeBacking = true
//        default:
//            break
//        }
//    }
//}
//
//public enum TabBarVisibility {
//    case visible, hidden, none
//}
//
//public enum NavigationBarType {
//    case native, none, notDetermined
//}
//
//extension BaseViewController: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        isMultipleGestureEnable ? !(gestureRecognizer is UIScreenEdgePanGestureRecognizer) : false
//    }
//}
