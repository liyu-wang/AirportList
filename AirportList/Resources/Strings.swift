//
//  Strings.swift
//  AirportList
//
//  Created by Liyu Wang on 11/11/21.
//

import Foundation

enum Strings {
    enum Errors {
        static let generalTitle = NSLocalizedString(
            "errors.general.title",
            value: "Error",
            comment: "General title for error alert."
        )

        static let generalMessage = NSLocalizedString(
            "errors.general.message",
            value: "Something is not right, please try again later!",
            comment: "General message for error alert."
        )
    }
}
