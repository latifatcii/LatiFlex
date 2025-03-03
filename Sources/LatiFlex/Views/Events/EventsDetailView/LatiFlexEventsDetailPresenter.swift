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

private extension LatiFlexEventsDetailPresenter {
    enum Constant {
        static let customBarButtonFontSize: Double = 14
        static let customBarButtonTitle: String = "Copy"
    }
}

final class LatiFlexEventsDetailPresenter {
    private weak var view: LatiFlexEventsDetailViewInterface?
    private let router: LatiFlexEventsDetailRouterInterface
    private let eventParameters: [String: Any]?
    private let eventError: Error?

    init(view: LatiFlexEventsDetailViewInterface?,
         router: LatiFlexEventsDetailRouterInterface,
         eventParameters: [String: Any]?,
         eventError: Error?) {
        self.view = view
        self.router = router
        self.eventParameters = eventParameters
        self.eventError = eventError
    }

    @objc
    private func copyButtonTapped() {
        let prettyPrintedEvent = eventParameters?.prettyPrintedString
        let responseText = prettyPrintedEvent ?? String(describing: eventError)
        view?.setPasteBoard(text: responseText)
    }
}

extension LatiFlexEventsDetailPresenter: LatiFlexEventsDetailPresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        if let eventParameters {
            view?.setResponseViewText(text: eventParameters.prettyPrintedString)
        } else if let eventError {
            view?.setResponseViewText(text: String(describing: eventError))
        }
        view?.setCustomBarButton(style: .textWithUIColor(color: .blue,
                                                         font: .systemFont(ofSize: Constant.customBarButtonFontSize),
                                                         title: Constant.customBarButtonTitle),
                                 position: .right,
                                 target: self,
                                 selector: #selector(copyButtonTapped))
    }

    func textDidChange(searchtext: String) {
        guard let eventParameters = eventParameters, !searchtext.isEmpty, let boldAttr = view?.boldAttr, let prettyPrinted = eventParameters.prettyPrintedString else {
            view?.setResponseViewText(text: eventParameters?.prettyPrintedString)
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
            view?.setResponseViewText(attributedText: suggestionAtt)
        } catch {
            view?.setResponseViewText(text: prettyPrinted)
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
