//
//  AirportRepository.swift
//  AirportList
//
//  Created by Liyu Wang on 3/1/22.
//

import Combine

protocol AirportRepositoryType {
    func getAirportList() -> AnyPublisher<[Airport], WebServiceError>
}

struct AirportRepository: AirportRepositoryType {
    private var cacheManager: CacheManagerType
    private let service: AirportServiceType

    init(
        cacheManager: CacheManagerType = FileBasedCacheManager(),
        service: AirportServiceType = AirportService()
    ) {
        self.cacheManager = cacheManager
        self.service = service
    }

    func getAirportList() -> AnyPublisher<[Airport], WebServiceError> {
        let cachePublisher = cacheManager.getCachedObject(of: [Airport].self)
            .eraseToAnyPublisher()
        let servicePublisher = service.fetchAirportList()
            .handleEvents(
                receiveOutput: { airports in
                    self.cacheManager.cache(airports)
                }
            )
            .eraseToAnyPublisher()

        return cachePublisher.merge(with: servicePublisher)
            .eraseToAnyPublisher()
    }
}
