//
//  SplitViewCoordinatorType.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 2/11/21.
//

import UIKit

protocol SplitViewCoordinatorType: CoordinatorType {
    var splitViewController: UISplitViewController { get }
    var primaryCoordinator: NavigationCoordinatorType { get }
    var secondaryCoordinator: NavigationCoordinatorType { get }
}

class SplitViewCoordinator: SplitViewCoordinatorType {
    let splitViewController: UISplitViewController
    let primaryCoordinator: NavigationCoordinatorType
    let secondaryCoordinator: NavigationCoordinatorType

    init(
        splitViewController: UISplitViewController,
        primaryCoordinator: NavigationCoordinatorType = NavigationCoordinator(),
        secondaryCoordinator: NavigationCoordinatorType = NavigationCoordinator()
    ) {
        self.splitViewController = splitViewController
        self.primaryCoordinator = primaryCoordinator
        self.secondaryCoordinator = secondaryCoordinator
    }

    func start() {
        primaryCoordinator.start()
        splitViewController.setViewController(primaryCoordinator.navigationController, for: .primary)
//        splitViewController.setViewController(secondaryCoordinator.navigationController, for: .secondary)
    }
}
