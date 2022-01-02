//
//  RequestConvertible.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation

enum Method: String {
    case DELETE
    case GET
    case POST
    case PUT
}

private enum Constants {
    static let baseURL = "https://api.qantas.com"
}

protocol RequestConvertible: CustomStringConvertible {
    var method: Method { get }
    var path: String { get }

    func toURLRequest() throws -> URLRequest
}

extension RequestConvertible {
    var description: String {
        "\(method.rawValue) /\(path)"
    }

    func toURLRequest() throws -> URLRequest {
        guard let url = URL(string: Constants.baseURL)?.appendingPathComponent(path) else {
            throw WebServiceError(errorKind: .invalidRequest, request: self)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
