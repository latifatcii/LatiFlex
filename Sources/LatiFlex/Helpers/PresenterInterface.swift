//
//  File.swift
//  
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

//import Foundation
//
//public protocol PresenterInterface: AnyObject {
//    func viewDidLoad()
//    func viewWillAppear()
//    func viewDidAppear()
//    func viewWillDisappear()
//    func viewDidDisappear()
//}
//
//public extension PresenterInterface {
//    func viewDidLoad() {}
//    func viewWillAppear() {}
//    func viewDidAppear() {}
//    func viewWillDisappear() {}
//    func viewDidDisappear() {}
//}
//
//public extension Array {
//    static var empty: Self { .init() }
//    
//    func chunk(into size: Int) -> [[Element]] {
//        return stride(from: 0, to: count, by: size).map {
//            Array(self[$0 ..< Swift.min($0 + size, count)])
//        }
//    }
//
//    func putElementToFirstIndex(satisfying: (Element) -> Bool) -> [Element] {
//        guard count > 1 else { return self }
//        guard let indexOfElement = firstIndex(where: { satisfying($0) }) else { return self }
//        var copyOfArray = self
//        let droppedElement = copyOfArray.remove(at: indexOfElement)
//        copyOfArray.insert(droppedElement, at: 0)
//        return copyOfArray
//    }
//
//    @discardableResult
//    mutating func removeSafely(at index: Int) -> Element? {
//        guard indices.contains(index) else { return nil }
//        return remove(at: index)
//    }
//
//    subscript(safe range: Range<Index>) -> [Element]? {
//        guard indices.contains(range.startIndex), indices.contains(range.endIndex - 1) else {
//            return nil
//        }
//
//        return Array(self[range.startIndex..<range.endIndex])
//    }
//}
