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
        let error: WebServiceError = .init(errorKind:.badServerResponse,
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


extension Airport {
    static let mock = Airport(
        airportCode: "AAA",
        airportName: "Anaa",
        domesticAirport: false,
        regionalAirport: false,
        onlineIndicator: false,
        eticketableAirport: false,
        location: Location.mock,
        city: City.mock,
        country: Country.mock,
        region: Region.mock)
}

extension Location {
    static let mock = Location(aboveSeaLevel: -99999,
                               latitude: 17.25,
                               latitudeRadius: -0.304,
                               longitude: 145.3,
                               longitudeRadius: -2.5395,
                               latitudeDirection: "S",
                               longitudeDirection: "W")
}

extension City {
    static let mock = City(cityCode: "AAA", cityName: "Anaa", timeZoneName: "Pacific/Tahiti")
}

extension Country {
    static let mock = Country(countryCode: "PF", countryName: "French Polynesia")
}

extension Region {
    static let mock = Region(regionCode: "SP", regionName: "South Pacific")
}
