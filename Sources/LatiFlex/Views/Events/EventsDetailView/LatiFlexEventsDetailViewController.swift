//
//  LatiFlexEventsDetailViewController.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexEventsDetailViewInterface: AnyObject {
    var boldAttr: [NSAttributedString.Key : Any] { get }

    func prepareUI()
    func setResponseViewText(text: String?)
    func setResponseViewText(attributedText: NSAttributedString?)
}

private extension LatiFlexEventsDetailViewController {
    enum Constant {
        static let responseViewFontSize: CGFloat = 12
        static let boldAttrFontSize: CGFloat = 16
    }
}

final class LatiFlexEventsDetailViewController: UIViewController {

    var presenter: LatiFlexEventsDetailPresenterInterface!

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

extension LatiFlexEventsDetailViewController: LatiFlexEventsDetailViewInterface {
    var boldAttr: [NSAttributedString.Key : Any] {
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constant.boldAttrFontSize, weight: .bold), .foregroundColor: UIColor.orange]
    }

    func prepareUI() {
        view.backgroundColor = .white

        responseView.embedEdgeToEdge(in: view, shouldEmbedSafeArea: true)
        responseView.isEditable = false
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    func setResponseViewText(text: String?) {
        responseView.text = text
    }

    func setResponseViewText(attributedText: NSAttributedString?) {
        responseView.attributedText = attributedText
    }
}

extension LatiFlexEventsDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange(searchtext: searchText)
    }
}
