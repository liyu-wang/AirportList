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

extension Airport {
    static let mock = Airport(
        airportCode: "abc",
        airportName: "abc",
        domesticAirport: true,
        regionalAirport: true,
        onlineIndicator: true,
        eticketableAirport: true,
        location: Location.mock,
        city: City.mock,
        country: Country.mock,
        region: Region.mock)
}

extension Location {
    static let mock = Location(aboveSeaLevel: 444,
                               latitude: 333,
                               latitudeRadius: 444,
                               longitude: 444,
                               longitudeRadius: 444,
                               latitudeDirection: "dd",
                               longitudeDirection: "dd")
}

extension City {
    static let mock = City(cityCode: "ddd", cityName: "ddd", timeZoneName: "ddd")
}

extension Country {
    static let mock = Country(countryCode: "ddd", countryName: "ddd")
}

extension Region {
    static let mock = Region(regionCode: "ddd", regionName: "ddd")
}
