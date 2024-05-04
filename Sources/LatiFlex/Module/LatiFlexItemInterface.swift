//
//  File.swift
//  
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

public protocol LatiFlexItemInterface {
    var image: UIImage? { get }
    
    func didSelectItem()
    func didSelectItem(deeplinks: LatiFlexDeeplinksResponse)
}

extension LatiFlexItemInterface {
    func didSelectItem() { }
    func didSelectItem(deeplinks: LatiFlexDeeplinksResponse) { }
}
