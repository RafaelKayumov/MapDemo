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
    private weak var listModule: ListInteractor?
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

    func instantiateListModuleAndReturnView() -> UIViewController {
        let listEntities = assembleList(dataProvider: dataProvider)
        listModule = listEntities.module
        return listEntities.view
    }

    func instantiateRootTabbarController() -> UITabBarController {
        let mapModuleView = instantiateMapModuleAndReturnView()
        let listModuleView = instantiateListModuleAndReturnView()

        mapModuleView.tabBarItem.image = #imageLiteral(resourceName: "map")
        listModuleView.tabBarItem.image = #imageLiteral(resourceName: "list")

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [mapModuleView, listModuleView]

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

    func assembleList(dataProvider: MapObjectsDataProvider) -> (module: ListInteractor, view: ListViewController) {
        let view = ListViewController.instantiate()
        let module = ListInteractor(dataProvider: dataProvider, view: view)
        view.output = module

        return (module, view)
    }
}
