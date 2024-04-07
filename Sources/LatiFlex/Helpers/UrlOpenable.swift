//
//  UrlOpenable.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

public protocol UrlOpenable: AnyObject {
    func canOpenUrl(_ url: URL) -> Bool
    func canOpenUrl(_ urlString: String) -> Bool
    func openUrl(_ url: URL, completion: ((Bool) -> Void)?)
    func openUrl(_ urlString: String, completion: ((Bool) -> Void)?)
}

public extension UrlOpenable {
    func canOpenUrl(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    func canOpenUrl(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    func openUrl(_ url: URL, completion: ((Bool) -> Void)? = nil) {
        guard canOpenUrl(url) else {
            completion?(false)
            return
        }
        UIApplication.shared.open(url, completionHandler: completion)
    }
    
    func openUrl(_ urlString: String, completion: ((Bool) -> Void)?) {
        guard let url = URL(string: urlString), canOpenUrl(url) else {
            completion?(false)
            return
        }
        UIApplication.shared.open(url, completionHandler: completion)
    }
}
