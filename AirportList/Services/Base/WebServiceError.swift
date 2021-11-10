//
//  WebServiceError.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation

protocol WebServiceErrorType: LocalizedError {
    var errorTitle: String { get }
    var errorMessage: String { get }
}

struct WebServiceError: WebServiceErrorType {
    enum ErrorKind {
        case invalidRequest
        case badServerResponse
        case networkingError
        case decodingError
        case unknown
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

    var errorDescription: String? {
        switch kind {
        case .invalidRequest:
            return "Invalid request: \(request)"
        case .badServerResponse:
            return "Bad response: \(request)"
        case .networkingError, .decodingError:
            return underlyingError?.localizedDescription
        case .unknown:
            return "Unkown error: \(request)"
        }
    }
}

extension WebServiceErrorType {
    var errorTitle: String {
        Strings.Errors.generalTitle
    }

    var errorMessage: String {
#if DEBUG
        localizedDescription
#else
        Strings.Errors.generalMessage
#endif
    }
}
