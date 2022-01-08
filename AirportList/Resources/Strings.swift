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

    enum Navigation {
        static let listVCTitle = NSLocalizedString(
            "navigation.listVC.title",
            value: "List",
            comment: "List view controller title")

        static let detailsVCTitle = NSLocalizedString(
            "navigation.detailsVC.title",
            value: "Details",
            comment: "Details view controller title")
    }

    enum Alerts {
        static let okButtonTitle = NSLocalizedString(
            "alert.okButton.title",
            value: "Ok",
            comment: "Ok button title for alert")
    }

    enum Buttons {
        static let goBackTitle = NSLocalizedString(
            "Buttons.goBack.title",
            value: "Go back",
            comment: "Go back button title")
    }
}
