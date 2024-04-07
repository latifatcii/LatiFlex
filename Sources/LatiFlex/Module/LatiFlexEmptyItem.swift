//
//  File.swift
//  
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

final class LatiFlexEmptyItem: LatiFlexItemInterface {
    var image: UIImage? {
        UIImage(named: "debuggerKit", in: .module, with: .none)
    }
    
    func didSelectItem() {}
}
