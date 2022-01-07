//
//  CacheManager.swift
//  AirportList
//
//  Created by Liyu Wang on 3/1/22.
//

import Combine
import Foundation

protocol CacheManagerType {
    func cache<T: Codable>(_ object: T)
    func getCachedObject<T: Codable>(of type: T.Type) -> AnyPublisher<T, WebServiceError>
    func removeCache<T: Codable>(for type: T.Type)
}

class FileBasedCacheManager: CacheManagerType {

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    func url<T: Codable>(for type: T.Type) -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first?
            .appendingPathComponent(String(describing: type))
            .appendingPathExtension("json")
    }

    func cache<T: Codable>(_ object: T) {
        guard let url = url(for: type(of: object)) else { return }

        do {
            let data = try self.encoder.encode(object)
            try data.write(to: url, options: [.atomic])
        } catch {
#if DEBUG
            fatalError(error.localizedDescription)
#endif
        }
    }

    func getCachedObject<T: Codable>(of type: T.Type) -> AnyPublisher<T, WebServiceError> {
        guard
            let url = url(for: type),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return Empty()
                .setFailureType(to: WebServiceError.self)
                .eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let obj = try self.decoder.decode(T.self, from: data)
            return Just(obj)
                .setFailureType(to: WebServiceError.self)
                .eraseToAnyPublisher()
        } catch {
#if DEBUG
            fatalError(error.localizedDescription)
#else
            return Empty()
                .setFailureType(to: WebServiceError.self)
                .eraseToAnyPublisher()
#endif
        }
    }

    func removeCache<T: Codable>(for type: T.Type) {
        guard
            let url = url(for: type),
            FileManager.default.fileExists(atPath: url.path)
        else { return }

        do {
            try FileManager.default.removeItem(at: url)
        } catch {
#if DEBUG
            fatalError(error.localizedDescription)
#endif
        }
    }
}
