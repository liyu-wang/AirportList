//
//  Mocks.swift
//  AirportListTests
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation
import Combine
@testable import AirportList

class MockCacheManager: FileBasedCacheManager {
    override func url<T: Codable>(for type: T.Type) -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first?
            .appendingPathComponent("Testing")
            .appendingPathExtension("json")
    }
}

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

extension AirportCellModel {
    static func makeMock(
        airport: Airport = Airport.makeMock()
    ) -> AirportCellModel {
        return AirportCellModel(airport: airport)
    }
}

extension Airport {
    static func makeMock(
        airportCode: String = "AAA",
        airportName: String = "Anaa",
        domesticAirport: Bool = false,
        regionalAirport: Bool = false,
        onlineIndicator: Bool = false,
        eticketableAirport: Bool = false,
        location: Location = Location.makeMock(),
        city: City = City.makeMock(),
        country: Country = Country.makeMock(),
        region: Region = Region.makeMock()
    ) -> Airport {
        return Airport(
            airportCode: airportCode,
            airportName: airportName,
            domesticAirport: domesticAirport,
            regionalAirport: regionalAirport,
            onlineIndicator: onlineIndicator,
            eticketableAirport: eticketableAirport,
            location: location,
            city: city,
            country: country,
            region: region
        )
    }
}

extension Location {
    static func makeMock(
        aboveSeaLevel: Int = -99999,
        latitude: Double = 17.25,
        latitudeRadius: Double = -0.304,
        longitude: Double = 145.3,
        longitudeRadius: Double = -2.5395,
        latitudeDirection: String = "S",
        longitudeDirection: String = "W"
    ) -> Location {
        return Location(
            aboveSeaLevel: aboveSeaLevel,
            latitude: latitude,
            latitudeRadius: latitudeRadius,
            longitude: longitude,
            longitudeRadius: longitudeRadius,
            latitudeDirection: latitudeDirection,
            longitudeDirection: longitudeDirection
        )
    }
}

extension City {
    static func makeMock(
        cityCode: String = "AAA",
        cityName: String = "Anaa",
        timeZoneName: String = "Pacific/Tahiti"
    ) -> City {
        return City(
            cityCode: cityCode,
            cityName: cityName,
            timeZoneName: timeZoneName
        )
    }
}

extension Country {
    static func makeMock(
        countryCode: String = "PF",
        countryName: String = "French Polynesia"
    ) -> Country {
        return Country(
            countryCode: countryCode,
            countryName: countryName
        )
    }
}

extension Region {
    static func makeMock(
        regionCode: String = "SP",
        regionName: String = "South Pacific"
    ) -> Region {
        return Region(
            regionCode: regionCode,
            regionName: regionName
        )
    }
}
