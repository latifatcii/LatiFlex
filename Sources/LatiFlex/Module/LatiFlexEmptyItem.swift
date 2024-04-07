//
//  File.swift
//  
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

final class LatiFlexEmptyItem: LatiFlexItemInterface {
    var image: UIImage? {
        UIImage(named: "latiflex", in: .main, with: .none)
    }
    
    func didSelectItem() {}
}
