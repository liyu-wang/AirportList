//
//  AirportServiceTests.swift
//  AirportListTests
//
//  Created by Liyu Wang on 9/11/21.
//

import XCTest
import Combine
@testable import AirportList

class AirportServiceTests: XCTestCase {

    var airportService: AirportServiceType!
    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        airportService = AirportService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        airportService = nil
        cancellable?.cancel()
        cancellable = nil
    }

    func testFetchingAirports() throws {
        let expectation = expectation(description: "Fetch a list of airports.")

        cancellable = airportService.fetchAirportList()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    XCTFail("Failed to fetch airports list.")
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { airports in
                XCTAssertTrue(airports.count > 0, "Airports number is not greater than 0.")
            }

        wait(for: [expectation], timeout: 3)
    }

}
