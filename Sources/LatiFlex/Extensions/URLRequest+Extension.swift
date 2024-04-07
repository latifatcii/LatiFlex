//
//  URLRequest+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 8.04.2024.
//

import Foundation

extension URLRequest {
    var curlString: String {
        guard let url = url else { return "" }
          var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        } else if let data = try? httpBodyStream?.readData(),
                  let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}

enum StreamError: Error {
    case Error(error: Error?, partialData: [UInt8])
}

extension InputStream {
    public func readData(bufferSize: Int = 1024) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var data: [UInt8] = []

        open()

        while true {
            let count = read(&buffer, maxLength: buffer.capacity)

            guard count >= 0 else {
                close()
                throw StreamError.Error(error: streamError, partialData: data)
            }

            guard count != 0 else {
                close()
                return Data(data)
            }

            data.append(contentsOf: (buffer.prefix(count)))
        }
    }
}
