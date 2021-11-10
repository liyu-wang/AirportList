//
//  ListViewModel.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation
import Combine

protocol ListViewModelType {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<WebServiceError, Never> { get }
    var reloadTablePublisher: AnyPublisher<Void, Never> { get }

    var numberOfRows: Int { get }
    func item(at indexPath: IndexPath) -> Airport
    func fetchAirports()
}

struct ListViewModel: ListViewModelType {
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<WebServiceError, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    var reloadTablePublisher: AnyPublisher<Void, Never> {
        reloadTableSubject.eraseToAnyPublisher()
    }

    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<WebServiceError, Never>()
    private let reloadTableSubject = PassthroughSubject<Void, Never>()
    private let service: AirportServiceType

    init(service: AirportServiceType = AirportService()) {
        self.service = service
        fetchAirports()
    }

    var numberOfRows: Int {
        0
    }

    func item(at indexPath: IndexPath) -> Airport {
        Airport.mock
    }

    func fetchAirports() {

    }
}
