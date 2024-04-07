//
//  UICollectionView+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

//import UIKit
//
//public extension UICollectionView {
//
//    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
//        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
//            fatalError()
//        }
//
//        return cell
//    }
//}
//
//public extension UICollectionReusableView {
//    class func getNib(for bundle: Bundle) -> UINib {
//        return UINib(nibName: className, bundle: bundle)
//    }
//
//    class var identifier: String {
//        return className
//    }
//}
//
//public extension NSObject {
//    @objc var className: String {
//        return type(of: self).className
//    }
//
//    @objc static var className: String {
//        return String(describing: self)
//    }
//}
