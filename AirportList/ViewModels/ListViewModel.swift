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

class ListViewModel: ListViewModelType {

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
    private var airports: [Airport] = []

    private var cancellables = Set<AnyCancellable>()

    init(service: AirportServiceType = AirportService()) {
        self.service = service
    }

    var numberOfRows: Int {
        airports.count
    }

    func item(at indexPath: IndexPath) -> Airport {
        airports[indexPath.row]
    }

    func fetchAirports() {
        isLoadingSubject.send(true)

        service.fetchAirportList()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.reloadTableSubject.send()
                case let .failure(error):
                    self.errorSubject.send(error)
                }
                self.isLoadingSubject.send(false)
            } receiveValue: { [weak self] airports in
                self?.airports = airports
            }
            .store(in: &cancellables)
    }
}
