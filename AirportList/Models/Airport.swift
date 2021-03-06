//
//  Airport.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import Foundation

struct Airport: Codable {
    var airportCode: String
    var airportName: String
    var domesticAirport: Bool
    var regionalAirport: Bool
    var onlineIndicator: Bool
    var eticketableAirport: Bool
    var location: Location
    var city: City
    var country: Country
    var region: Region
}

struct Location: Codable {
    var aboveSeaLevel: Int?
    var latitude: Double
    var latitudeRadius: Double
    var longitude: Double
    var longitudeRadius: Double
    var latitudeDirection: String?
    var longitudeDirection: String?
}

struct City: Codable {
    var cityCode: String
    var cityName: String?
    var timeZoneName: String
}

struct Country: Codable {
    var countryCode: String
    var countryName: String
}

struct Region: Codable {
    var regionCode: String
    var regionName: String
}

extension Airport: Equatable {
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        lhs.airportCode == rhs.airportCode
    }
}
