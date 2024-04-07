//
//  LatiFlexNetworkDetailResponsePresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation
import UIKit

protocol LatiFlexNetworkDetailResponsePresenterInterface {
    func viewDidLoad()
    func textDidChange(searchtext: String)
    func searchBarSearchButtonClicked()
}

private extension LatiFlexNetworkDetailResponsePresenter {
    enum Constant {
        static let customBarButtonFontSize: Double = 14
        static let customBarButtonTitle: String = "Copy Response"
    }
}

final class LatiFlexNetworkDetailResponsePresenter {
    private weak var view: LatiFlexNetworkDetailResponseViewInterface?
    private let response: String?
    private var matches: [NSTextCheckingResult] = []
    private var currentRangeIndex: Int = .zero
    
    init(view: LatiFlexNetworkDetailResponseViewInterface?,
         response: String?) {
        self.view = view
        self.response = response
    }
    
    @objc private func copyButtonTapped() {
        guard let response = response else { return }
        view?.setToPasteboard(response)
    }
}

extension LatiFlexNetworkDetailResponsePresenter: LatiFlexNetworkDetailResponsePresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        
        view?.setResponseView(text: response)
        view?.setCustomBarButton(style: .textWithUIColor(color: .blue,
                                                         font: .systemFont(ofSize: Constant.customBarButtonFontSize),
                                                         title: Constant.customBarButtonTitle),
                                 position: .right,
                                 target: self,
                                 selector: #selector(copyButtonTapped))
    }
    
    func textDidChange(searchtext: String) {
        guard let response = response, !searchtext.isEmpty, let boldAttr = view?.boldAttr else {
            view?.setResponseView(text: response)
            view?.setResponseViewScrollToTop()
            return
        }
        
        let suggestionAtt = NSMutableAttributedString(string: response)
        var firstRange: NSRange? = NSRange()
        do {
            let regex = try NSRegularExpression(pattern: searchtext.lowercased(), options: .caseInsensitive)
            let range = NSRange(location: .zero, length: response.count)
            matches = regex.matches(in: response.lowercased(), options: [], range: range)
            firstRange = matches.first?.range
            for match in matches {
                suggestionAtt.addAttributes(boldAttr, range: match.range)
            }
            view?.setResponseView(attributedText: suggestionAtt)
            guard let firstRange = firstRange else { return }
            view?.setResponseViewScrollToRange(nsRange: firstRange)
        } catch {
            view?.setResponseView(text: response)
            view?.setResponseViewScrollToTop()
        }
    }
    
    func searchBarSearchButtonClicked() {
        guard matches.count > currentRangeIndex else {
            currentRangeIndex = .zero
            return
        }
        view?.setResponseViewScrollToRange(nsRange: matches[currentRangeIndex].range)
        currentRangeIndex += 1
    }
}
