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
        let cacheManager = MockCacheManager()
        cacheManager.removeCache(for: [Airport].self)

        let repository = AirportRepository(cacheManager: cacheManager, service: MockAirportService())
        viewModel = ListViewModel(repository: repository)

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
        let cacheManager = MockCacheManager()
        cacheManager.removeCache(for: [Airport].self)

        let repository = AirportRepository(cacheManager: cacheManager, service: MockAirportService())
        viewModel = ListViewModel(repository: repository)

        let expectation = expectation(description: "fetch airport")

        cancellable = viewModel.reloadTablePublisher
            .collect(1)
            .sink { completion in
                XCTFail("infinite publisher shouldn't complete")
            } receiveValue: { _ in
                XCTAssertEqual(self.viewModel.numberOfRows, 21)
                XCTAssertEqual(self.viewModel.cellModel(at: IndexPath(row: 0, section: 0)), AirportCellModel.makeMock())
                expectation.fulfill()
            }

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

    func testFetchAirportSuccessWithCache() throws {
        let cacheManager = MockCacheManager()
        cacheManager.removeCache(for: [Airport].self)
        let airports: [Airport] = MockUtils.shared.loadData(fileName: "AirportsData")!
        cacheManager.cache(airports)

        let repository = AirportRepository(cacheManager: cacheManager, service: MockAirportService())
        viewModel = ListViewModel(repository: repository)

        let expectation = expectation(description: "fetch airport")

        cancellable = viewModel.reloadTablePublisher
            .collect(2)
            .sink { completion in
                XCTFail("infinite publisher shouldn't complete")
            } receiveValue: { reloadTableSignalSequence in
                XCTAssertEqual(reloadTableSignalSequence.count, 2)

                XCTAssertEqual(self.viewModel.numberOfRows, 21)
                XCTAssertEqual(self.viewModel.cellModel(at: IndexPath(row: 0, section: 0)), AirportCellModel.makeMock())
                expectation.fulfill()
            }

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

    func testFetchAirportFailure() throws {
        let cacheManager = MockCacheManager()
        cacheManager.removeCache(for: [Airport].self)

        let repository = AirportRepository(cacheManager: cacheManager, service: MockAirportServiceWithError())
        viewModel = ListViewModel(repository: repository)

        let expectation = expectation(description: "Receive an error")

        cancellable = viewModel.errorPublisher
            .collect(1)
            .sink(receiveCompletion: { completion in
                XCTFail("infinite publisher shouldn't complete")
            }, receiveValue: { errorSequence in
                let errorKindSequence = errorSequence.map { $0.errorKind }
                XCTAssertEqual(errorKindSequence, [WebServiceError.ErrorKind.badServerResponse])
                expectation.fulfill()
            })

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }

    func testFetchAirportFailureWithCache() throws {
        let cacheManager = MockCacheManager()
        cacheManager.removeCache(for: [Airport].self)

        let repository = AirportRepository(cacheManager: cacheManager, service: MockAirportServiceWithError())
        viewModel = ListViewModel(repository: repository)

        let expectation = expectation(description: "Receive an error")

        cancellable = viewModel.errorPublisher
            .collect(1)
            .sink(receiveCompletion: { completion in
                XCTFail("infinite publisher shouldn't complete")
            }, receiveValue: { errorSequence in
                let errorKindSequence = errorSequence.map { $0.errorKind }
                XCTAssertEqual(errorKindSequence, [WebServiceError.ErrorKind.badServerResponse])
                expectation.fulfill()
            })

        viewModel.fetchAirports()
        wait(for: [expectation], timeout: 3)
    }
}
