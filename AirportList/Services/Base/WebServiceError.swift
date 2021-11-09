//
//  WebServiceError.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation

struct WebServiceError: LocalizedError {
    enum ErrorKind {
        case invalidURL
        case badServerResponse
        case networkingError
        case decodingError
        case other
    }

    let kind: ErrorKind
    let request: RequestConvertible
    let response: HTTPURLResponse?
    let underlyingError: Error?

    init(
        kind: ErrorKind,
        request: RequestConvertible,
        response: HTTPURLResponse? = nil,
        underlyingError: Error? = nil
    ) {
        self.kind = kind
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
}
