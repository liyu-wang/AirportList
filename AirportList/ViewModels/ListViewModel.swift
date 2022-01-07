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
    func cellModel(at indexPath: IndexPath) -> AirportCellModel
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
    private let repository: AirportRepositoryType
    private var airportCellModels: [AirportCellModel] = []

    private var cancellables = Set<AnyCancellable>()

    init(repository: AirportRepositoryType = AirportRepository()) {
        self.repository = repository
    }

    var numberOfRows: Int {
        airportCellModels.count
    }

    func cellModel(at indexPath: IndexPath) -> AirportCellModel {
        airportCellModels[indexPath.row]
    }

    func fetchAirports() {
        isLoadingSubject.send(true)

        repository.getAirportList()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.errorSubject.send(error)
                }
                self.isLoadingSubject.send(false)
            } receiveValue: { [weak self] airports in
                guard let self = self else { return }
                self.airportCellModels = airports.map { AirportCellModel(airport: $0) }
                self.reloadTableSubject.send()
            }
            .store(in: &cancellables)
    }
}
