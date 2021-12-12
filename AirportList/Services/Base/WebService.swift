//
//  WebService.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation
import Combine

extension URLSession {
    static let sharedSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        return session
    }()
}

protocol WebServiceType {
    func makeAPICall<T: Decodable>(with requestConvertible: RequestConvertible, for model: T.Type) -> AnyPublisher<T, WebServiceError>
}

extension WebServiceType {
    func makeAPICall<T: Decodable>(with requestConvertible: RequestConvertible, for model: T.Type) -> AnyPublisher<T, WebServiceError> {
        let request: URLRequest
        do {
            try request = requestConvertible.toURLRequest()
        } catch {
            return Fail(error: .init(kind: .invalidRequest, request: requestConvertible))
                .eraseToAnyPublisher()
        }

        return URLSession.sharedSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode)
                else {
                    throw WebServiceError(kind: .badServerResponse,
                                          request: requestConvertible,
                                          response: response as? HTTPURLResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case let webServiceError as WebServiceError:
                    return webServiceError
                case is URLError:
                    return WebServiceError(kind: .networkingError, request: requestConvertible, underlyingError: error)
                case is DecodingError:
                    return WebServiceError(kind: .decodingError, request: requestConvertible, underlyingError: error)
                default:
                    return WebServiceError(kind: .unknown, request: requestConvertible, underlyingError: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
