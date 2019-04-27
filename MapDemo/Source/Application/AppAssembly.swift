//
//  AppAssembly.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit

class AppAssembly {

    private weak var mapModule: MapInteractor?

    func instantiateMapModuleAndReturnView() -> UIViewController {
        let mapEntities = assembleMap()
        mapModule = mapEntities.module
        return mapEntities.view
    }

    func instantiateRootTabbarController() -> UITabBarController {
        let mapModuleView = instantiateMapModuleAndReturnView()

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [mapModuleView]

        return tabbarController
    }
}

private extension AppAssembly {

    func assembleMap() -> (module: MapInteractor, view: MapViewController) {
        let view = MapViewController.instantiate()
        let module = MapInteractor()
        view.output = module

        return (module, view)
    }
}
