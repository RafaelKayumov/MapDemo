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
    lazy private var dataProvider: MapObjectsDataProvider = {
        let paidParkingAreasService = MapObjectsLoadingService(type: .paidParkingArea)
        let paidParkingsService = MapObjectsLoadingService(type: .paidParking)
        let rechargeStationService = MapObjectsLoadingService(type: .rechargeStation)
        return MapObjectsDataProvider(paidParkingAreasService: paidParkingAreasService,
                                      paidParkingsService: paidParkingsService,
                                      rechargingStationsService: rechargeStationService)
    }()

    func instantiateMapModuleAndReturnView() -> UIViewController {
        let mapEntities = assembleMap(dataProvider: dataProvider)
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

    func assembleMap(dataProvider: MapObjectsDataProvider) -> (module: MapInteractor, view: MapViewController) {
        let view = MapViewController.instantiate()
        let module = MapInteractor(dataProvider: dataProvider, view: view)
        view.output = module

        return (module, view)
    }
}
