//
//  AppCoordinator.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit
import GEOSwift

class AppCoordinator {

    private var assembly: AppAssembly
    private(set) var navigationController: UINavigationController?
    private(set) var tabbarController: UITabBarController?
    private(set) var window: UIWindow?

    init(assembly: AppAssembly) {
        self.assembly = assembly
        assembly.coordinator = self
    }

    func setupUI() {
        let window = UIWindow()
        window.backgroundColor = UIColor.white

        let tabbarController = prepareRootTabbarController()
        let navigationController = UINavigationController(rootViewController: tabbarController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.navigationController = navigationController
        self.tabbarController = tabbarController
        self.window = window
    }

    func pushMapForSingleObject(_ object: Feature) {
        let viewController = prepareMapForSingleObject(object)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension AppCoordinator {

    func prepareRootTabbarController() -> UITabBarController {
        return assembly.instantiateRootTabbarController()
    }

    func prepareMapForSingleObject(_ object: Feature) -> UIViewController {
        return assembly.instantiateMapForSingleObjectAndReturnView(object)
    }
}
