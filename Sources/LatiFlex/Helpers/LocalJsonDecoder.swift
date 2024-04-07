//
//  LocalJsonDecoder.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import Foundation

@propertyWrapper
public struct LocalJson<Value: Decodable> {
    let bundle: Bundle
    let name: String

    public init(_ bundle: Bundle, _ name: String? = nil) {
        self.bundle = bundle
        if let name = name {
            self.name = name
        } else {
            let typeName = String(describing: Value.self)
            self.name = typeName
        }
    }

    public var wrappedValue: Value {
        get {
            try! LocalJsonDecoder.shared.read(for: Value.self, withName: name, bundle: bundle)
        }
        set {
            fatalError("set is not implemented")
        }
    }
}

public final class LocalJsonDecoder {
    private enum LocalJsonDecoderError: Error {
        case pathNotFound
        case contentOfFileCannotConvertedToString
        case jsonDataCannotCreated
        case jsonDecodingFailed
    }

    public static var shared: LocalJsonDecoder = { return LocalJsonDecoder() }()
    private let kJsonFileType = "json"

    private init() { }

    /// Read json from test bundle and decodes it into given response model
    ///
    /// - Parameter responseType: Type of response, should conform decodable protocol
    /// - Returns: Response model
    /// - Throws: An LocalJsonDecoderError, can be handle for debugging
    public func read<T: Decodable>(for responseType: T.Type, withName name: String, bundle: Bundle) throws -> T {
        guard let path = bundle.path(forResource: name, ofType: kJsonFileType) else { throw LocalJsonDecoderError.pathNotFound }
        guard let jsonString = try? String(contentsOfFile: path) else { throw LocalJsonDecoderError.contentOfFileCannotConvertedToString }
        guard let jsonData = jsonString.data(using: .utf8) else { throw LocalJsonDecoderError.jsonDataCannotCreated }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedObject
        } catch {
            throw LocalJsonDecoderError.jsonDecodingFailed
        }
    }
}
