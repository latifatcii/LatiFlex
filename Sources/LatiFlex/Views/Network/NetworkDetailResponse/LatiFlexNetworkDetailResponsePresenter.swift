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
    func saveButtonTapped(with text: String?)
    func responseTextDidChange(_ text: String?)
}

private extension LatiFlexNetworkDetailResponsePresenter {
    enum Constant {
        static let customBarButtonFontSize: Double = 14
        static let customBarButtonTitle: String = "Copy Response"
        static let successTitle = "Success"
        static let successMessage = "Response saved successfully"
        static let invalidJsonTitle = "Invalid JSON"
        static let invalidJsonMessage = "Please enter a valid JSON format"
    }
}

final class LatiFlexNetworkDetailResponsePresenter {
    private weak var view: LatiFlexNetworkDetailResponseViewInterface?
    private let response: String?
    private let originalUrl: String?
    private var matches: [NSTextCheckingResult] = []
    private var currentRangeIndex: Int = .zero
    
    init(view: LatiFlexNetworkDetailResponseViewInterface?,
         response: String?,
         originalUrl: String?) {
        self.view = view
        self.response = response
        self.originalUrl = originalUrl
    }
    
    private func saveMockResponse(_ response: String?) {
        guard let urlString = originalUrl,
              let url = URL(string: urlString),
              let response = response else { return }
        
        LatiFlexNetworkInterceptor.shared.saveMockResponse(response, for: url)
    }
    
    private func getSavedMockResponse() -> String? {
        guard let urlString = originalUrl,
              let url = URL(string: urlString) else { return nil }
        
        return LatiFlexNetworkInterceptor.shared.shouldUseMockResponse(for: url)
    }
    
    private func isValidJson(_ jsonString: String) -> Bool {
        guard let data = jsonString.data(using: .utf8) else { return false }
        do {
            _ = try JSONSerialization.jsonObject(with: data)
            return true
        } catch {
            return false
        }
    }

    @objc private func copyButtonTapped() {
        let currentResponse = getSavedMockResponse() ?? response
        guard let responseText = currentResponse else { return }
        view?.setToPasteboard(responseText)
    }
}

extension LatiFlexNetworkDetailResponsePresenter: LatiFlexNetworkDetailResponsePresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        
        // Önce kaydedilmiş mock response'u kontrol et
        if let savedResponse = getSavedMockResponse() {
            view?.setResponseView(text: savedResponse)
        } else {
            view?.setResponseView(text: response)
        }
        
        // Copy Response butonu her zaman sağda
        if let view = view {
            let copyButton = UIBarButtonItem(title: Constant.customBarButtonTitle,
                                           style: .plain,
                                           target: self,
                                           action: #selector(copyButtonTapped))
            
            if var rightButtons = view.associatedNavigationItem.rightBarButtonItems {
                rightButtons.append(copyButton)
                view.associatedNavigationItem.rightBarButtonItems = rightButtons
            } else {
                view.associatedNavigationItem.rightBarButtonItems = [copyButton]
            }
        }
    }
    
    func textDidChange(searchtext: String) {
        let currentResponse = getSavedMockResponse() ?? response
        guard let responseText = currentResponse, !searchtext.isEmpty, let boldAttr = view?.boldAttr else {
            view?.setResponseView(text: currentResponse)
            view?.setResponseViewScrollToTop()
            return
        }
        
        let suggestionAtt = NSMutableAttributedString(string: responseText)
        var firstRange: NSRange? = NSRange()
        do {
            let regex = try NSRegularExpression(pattern: searchtext.lowercased(), options: .caseInsensitive)
            let range = NSRange(location: .zero, length: responseText.count)
            matches = regex.matches(in: responseText.lowercased(), options: [], range: range)
            firstRange = matches.first?.range
            for match in matches {
                suggestionAtt.addAttributes(boldAttr, range: match.range)
            }
            view?.setResponseView(attributedText: suggestionAtt)
            guard let firstRange = firstRange else { return }
            view?.setResponseViewScrollToRange(nsRange: firstRange)
        } catch {
            view?.setResponseView(text: currentResponse)
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
    
    func saveButtonTapped(with text: String?) {
        guard let text = text else { return }
        
        if isValidJson(text) {
            saveMockResponse(text)
            view?.showSuccessAlert(title: Constant.successTitle, message: Constant.successMessage)
            view?.setSaveButtonEnabled(false)
        } else {
            view?.showErrorAlert(title: Constant.invalidJsonTitle, message: Constant.invalidJsonMessage)
        }
    }
    
    func responseTextDidChange(_ text: String?) {
        guard let text = text else { return }
        view?.setSaveButtonEnabled(true)
        
        if !isValidJson(text) {
            view?.showInvalidJsonIndicator()
        } else {
            view?.hideInvalidJsonIndicator()
        }
    }
}
