//
//  Mocks.swift
//  AirportListTests
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation
import Combine
@testable import AirportList

struct MockAirportService: AirportServiceType {
    func fetchAirportList() -> AnyPublisher<[Airport], WebServiceError> {
        let airports: [Airport] = MockUtils.shared.loadData(fileName: "AirportsData")!
        return Just(airports)
            .setFailureType(to: WebServiceError.self)
            .eraseToAnyPublisher()
    }
}

struct MockAirportServiceWithError: AirportServiceType {
    func fetchAirportList() -> AnyPublisher<[Airport], WebServiceError> {
        let error: WebServiceError = .init(kind:.badServerResponse,
                                           request: AirportAPIDefinition.fetchAirportList)
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}

class MockUtils {
    static let shared = MockUtils()

    lazy var currentBundle = Bundle(for: type(of: self))

    func loadData<T: Decodable>(fileName: String, type: String = "json", bundle: Bundle = MockUtils.shared.currentBundle) -> T? {
        guard
            let url = bundle.url(forResource: fileName, withExtension: type),
            let data = try? Data(contentsOf: url, options: .mappedIfSafe)
        else { return nil }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
