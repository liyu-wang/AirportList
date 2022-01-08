//
//  MainCoordinator.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 3/11/21.
//

import Foundation

protocol AirportNavigatable {
    func showAirportDetails(_ airport: Airport)
}

class MainNavigaitonCoordinator: NavigationCoordinator, AirportNavigatable {
    override func start() {
        let ListVC = ListViewController(airportNavigatable: self)
        navigationController.pushViewController(ListVC, animated: false)
    }

    func showAirportDetails(_ airport: Airport) {
        let detailsViewModel = DetailsViewModel(airport: airport)
        let detailsVC = DetailsViewController(detailsViewModel: detailsViewModel)
        navigationController.pushViewController(detailsVC, animated: true)
    }
}

class MainSplitCoordinator: SplitViewCoordinator, AirportNavigatable {
    override func start() {
        let ListVC = ListViewController(airportNavigatable: self)
        primaryCoordinator.navigationController.setViewControllers([ListVC], animated: false)
        super.start()
    }

    func showAirportDetails(_ airport: Airport) {
        let detailsViewModel = DetailsViewModel(airport: airport)
        let detailsVC = DetailsViewController(detailsViewModel: detailsViewModel)
        secondaryCoordinator.navigationController.setViewControllers([detailsVC], animated: false)
        splitViewController.showDetailViewController(secondaryCoordinator.navigationController, sender: nil)
    }
}
