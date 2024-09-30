//
//  LatiFlexEventsDetailPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexEventsDetailPresenterInterface {
    func textDidChange(searchtext: String)
    func viewDidLoad()
}

final class LatiFlexEventsDetailPresenter {
    private weak var view: LatiFlexEventsDetailViewInterface?
    private let router: LatiFlexEventsDetailRouterInterface
    private let eventParameters: [String: Any]?

    init(view: LatiFlexEventsDetailViewInterface?,
         router: LatiFlexEventsDetailRouterInterface,
         eventParameters: [String: Any]?) {
        self.view = view
        self.router = router
        self.eventParameters = eventParameters
    }
}

extension LatiFlexEventsDetailPresenter: LatiFlexEventsDetailPresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        view?.setEventParametersLabel(text: eventParameters?.prettyPrintedString)
    }
    
    func textDidChange(searchtext: String) {
        guard let eventParameters = eventParameters, !searchtext.isEmpty, let boldAttr = view?.boldAttr, let prettyPrinted = eventParameters.prettyPrintedString else {
            view?.setEventParametersLabel(text: eventParameters?.prettyPrintedString)
            return
        }
        
        let suggestionAtt = NSMutableAttributedString(string: prettyPrinted)
        do {
            let regex = try NSRegularExpression(pattern: searchtext.lowercased(), options: .caseInsensitive)
            let range = NSRange(location: .zero, length: prettyPrinted.count)
            let matches = regex.matches(in: prettyPrinted.lowercased(), options: [], range: range)
            for match in matches {
                suggestionAtt.addAttributes(boldAttr, range: match.range)
            }
            view?.setEventParametersLabel(attributedText: suggestionAtt)
        } catch {
            view?.setEventParametersLabel(text: prettyPrinted)
        }
    }
}

private extension Dictionary {
    var prettyPrintedString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}

