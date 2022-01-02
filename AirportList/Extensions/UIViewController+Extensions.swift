//
//  UIViewController+Extensions.swift
//  AirportList
//
//  Created by Liyu Wang on 26/12/21.
//

import UIKit

extension UIViewController {
    func displayAlert(for error: WebServiceError) {
        let alertController = UIAlertController(
            title: error.errorTitle,
            message: error.errorDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
