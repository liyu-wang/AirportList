//
//  ListViewModelTests.swift
//  AirportListTests
//
//  Created by Liyu Wang on 9/11/21.
//

import XCTest
import Combine
@testable import AirportList

class ListViewModelTests: XCTestCase {

    var viewModel: ListViewModelType!
    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        cancellable?.cancel()
        cancellable = nil
    }

    func testIsLoadingSequence() throws {
        viewModel = ListViewModel(service: MockAirportService())

        let expectation = expectation(description: "loading flag sequence to be [true, false]")

        cancellable = viewModel.isLoadingPublisher
            .collect(.byTime(DispatchQueue.global(qos: .default), .seconds(2)))
            .sink { completion in
                XCTFail("infinite publisher shouldn't complete")
            } receiveValue: { isloadingSequence in
                XCTAssertEqual(isloadingSequence, [true, false])
                expectation.fulfill()
            }

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

    func testFetchAirportSuccess() throws {
        viewModel = ListViewModel(service: MockAirportService())

        let expectation = expectation(description: "fetch airport")

        cancellable = viewModel.reloadTablePublisher
            .collect(1)
            .sink { completion in
                XCTFail("infinite publisher shouldn't complete")
            } receiveValue: { _ in
                XCTAssertEqual(self.viewModel.numberOfRows, 21)
                expectation.fulfill()
            }

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

    func testFetchAirportFailure() throws {
        viewModel = ListViewModel(service: MockAirportServiceWithError())

        let expectation = expectation(description: "Receive an error")

        cancellable = viewModel.errorPublisher
            .collect(1)
            .sink(receiveCompletion: { completion in
                XCTFail("infinite publisher shouldn't complete")
            }, receiveValue: { errorSequence in
                let errorKindSequence = errorSequence.map { $0.kind }
                XCTAssertEqual(errorKindSequence, [WebServiceError.ErrorKind.badServerResponse])
                expectation.fulfill()
            })

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

}
