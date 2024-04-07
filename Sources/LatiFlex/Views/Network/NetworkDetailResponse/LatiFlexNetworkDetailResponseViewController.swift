//
//  LatiFlexNetworkDetailResponseViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkDetailResponseViewInterface: AnyObject, NavigationBarCustomButtonConfigurable {
    var boldAttr: [NSAttributedString.Key : Any] { get }
    
    func prepareUI()
    func setResponseView(text: String?)
    func setResponseView(attributedText: NSAttributedString?)
    func setResponseViewScrollToRange(nsRange: NSRange)
    func setResponseViewScrollToTop()
    func setToPasteboard(_ text: String)
}

private extension LatiFlexNetworkDetailResponseViewController {
    enum Constant {
        static let responseViewFontSize: CGFloat = 12
        static let boldAttrFontSize: CGFloat = 16
    }
}

final class LatiFlexNetworkDetailResponseViewController: UIViewController {
    var presenter: LatiFlexNetworkDetailResponsePresenterInterface!
    
    private let responseView: UITextView = {
        let responseView = UITextView()
        responseView.font = .systemFont(ofSize: Constant.responseViewFontSize)
        return responseView
    }()
    
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension LatiFlexNetworkDetailResponseViewController: LatiFlexNetworkDetailResponseViewInterface {
    var associatedNavigationItem: UINavigationItem { navigationItem }
    
    var boldAttr: [NSAttributedString.Key : Any] {
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constant.boldAttrFontSize, weight: .bold), .foregroundColor: UIColor.orange]
    }
    
    func prepareUI() {
        view.backgroundColor = .white
        responseView.embedEdgeToEdge(in: view)
        responseView.isEditable = false
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func setResponseView(text: String?) {
        responseView.text = text
    }
    
    func setResponseView(attributedText: NSAttributedString?) {
        responseView.attributedText = attributedText
    }
    
    func setResponseViewScrollToTop() {
        responseView.scrollToTop(animated: true)
    }
    
    func setResponseViewScrollToRange(nsRange: NSRange) {
        responseView.scrollRangeToVisible(nsRange)
    }
    
    func setToPasteboard(_ text: String) { UIPasteboard.general.string = text }
}

extension LatiFlexNetworkDetailResponseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSearchButtonClicked()
    }
}

private extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let newContentOffset = CGPoint(x: contentOffset.x, y: -contentInset.top)
        setContentOffset(newContentOffset, animated: animated)
    }
}
