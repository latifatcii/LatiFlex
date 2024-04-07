//
//  ViewInterface.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

//import UIKit
//
//public protocol ViewInterface: AnyObject {
//    static var storyboardId: String { get }
//
//    func setNavigationItemTitle(_ title: String)
//    func setTitle(_ title: String)
//    func setTitleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key : Any])
//    func setNavigationBarTintColor(_ color: UIColor)
//    func addBorderToNavigationBar()
//    func removeBorderFromNavigationBar()
//    func setNavigationBarHidden(_ shouldHide: Bool, animated: Bool)
//    func setNavigationBarHidden(_ shouldHide: Bool)
//    func setDefinesPresentationContext(_ shouldDefine: Bool)
//}
//
//public extension ViewInterface where Self: UIViewController {
//    static var storyboardId: String {
//        String(describing: self)
//    }
//
//    func setNavigationItemTitle(_ title: String) {
//        navigationItem.title = title
//    }
//    
//    func setTitle(_ title: String) {
//        self.title = title
//    }
//    
//    func setTitleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key : Any]) {
//        navigationController?.navigationBar.standardAppearance.titleTextAttributes = titleTextAttributes
//
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        }
//    }
//    
//    func setNavigationBarTintColor(_ color: UIColor) {
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.standardAppearance.backgroundColor = color
//
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        }
//    }
//    
//    func removeBorderFromNavigationBar() {
//        navigationController?.navigationBar.standardAppearance.shadowColor = nil
//
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        }
//    }
//    
//    func addBorderToNavigationBar() {
//        navigationController?.navigationBar.standardAppearance.shadowColor = .systemGray4
//
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.scrollEdgeAppearance
//        }
//    }
//
//    func setNavigationBarHidden(_ shouldHide: Bool) {
//        setNavigationBarHidden(shouldHide, animated: false)
//    }
//    
//    func setNavigationBarHidden(_ shouldHide: Bool, animated: Bool) {
//        navigationController?.setNavigationBarHidden(shouldHide, animated: animated)
//    }
//    
//    func setDefinesPresentationContext(_ shouldDefine: Bool) {
//        definesPresentationContext = shouldDefine
//    }
//}
