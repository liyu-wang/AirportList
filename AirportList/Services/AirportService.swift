//
//  AirportService.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation
import Combine

enum AirportAPIDefinition: RequestConvertible {
    case fetchAirportList

    var method: Method {
        .GET
    }

    var path: String {
        "flight/refData/airport"
    }
}

protocol AirportServiceType {
    func fetchAirportList() -> AnyPublisher<[Airport], WebServiceError>
}

class AirportService: WebService, AirportServiceType {
    func fetchAirportList() -> AnyPublisher<[Airport], WebServiceError> {
        return makeAPICall(with: AirportAPIDefinition.fetchAirportList, for: [Airport].self)
    }
}
