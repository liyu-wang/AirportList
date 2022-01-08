//
//  AirportCellModel.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 25/10/21.
//

import Foundation
import UIKit

struct AirportCellModel {
    var airportName: String {
        airport.airportName
    }
    
    var country: String {
        airport.country.countryName
    }

    let airport: Airport

    init(airport: Airport) {
        self.airport = airport
    }
}

extension AirportCellModel: Equatable {
    static func == (lhs: AirportCellModel, rhs: AirportCellModel) -> Bool {
        return lhs.airport == rhs.airport
    }
}
