//
//  AppCoordinator.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit

class AppCoordinator {

    private var appAssembly: AppAssembly
    private(set) var navigationController: UINavigationController?
    private(set) var tabbarController: UITabBarController?
    private(set) var window: UIWindow?

    init(appAssembly: AppAssembly) {
        self.appAssembly = appAssembly
    }

    func setupUI() {
        let window = UIWindow()
        window.backgroundColor = UIColor.white

        let tabbarController = UITabBarController()
        let navigationController = UINavigationController(rootViewController: tabbarController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.navigationController = navigationController
        self.tabbarController = tabbarController
        self.window = window
    }
}
