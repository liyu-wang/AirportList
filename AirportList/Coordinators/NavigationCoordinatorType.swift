//
//  NavigationCoordinatorType.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 2/11/21.
//

import UIKit

protocol CoordinatorType: AnyObject {
    func start()
}

protocol NavigationCoordinatorType: CoordinatorType {
    var children: [CoordinatorType] { get }
    var navigationController: UINavigationController { get }

    func addChild(_ coordinator: CoordinatorType)
    func removeChild(_ coordinator: CoordinatorType)
}

class NavigationCoordinator: NavigationCoordinatorType {
    var children: [CoordinatorType] {
        childCoordinators
    }
    let navigationController: UINavigationController

    private var childCoordinators = [CoordinatorType]()

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func addChild(_ coordinator: CoordinatorType) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: CoordinatorType) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    func start() {

    }
}
