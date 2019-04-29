//
//  ListInteractor.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation
import GEOSwift

class ListInteractor {

    private unowned var dataProvider: MapObjectsDataProvider
    private unowned var view: ListViewController
    private unowned var coordinator: AppCoordinator

    init(dataProvider: MapObjectsDataProvider, view: ListViewController, coordinator: AppCoordinator) {
        self.dataProvider = dataProvider
        self.view = view
        self.coordinator = coordinator
    }
}

extension ListInteractor: ListViewOutput {

    func onViewReady() {

    }

    func onWillAppear() {
        dataProvider.bakeBoundingRectObjects()
    }

    func triggerObjectsRefresh() {
        let presentables = dataProvider.boundingRectObjects.map { $0.presentable() }
        view.display(presentables)
    }

    func objectFor(_ index: Int) -> Feature? {
        let boundingRectObjects = dataProvider.boundingRectObjects
        guard boundingRectObjects.indices.contains(index) else { return nil }
        return boundingRectObjects[index]
    }

    func onObjectSelectFor(_ index: Int) {
        let objects = dataProvider.boundingRectObjects
        guard objects.indices.contains(index) else { return }
        let object = objects[index]
        coordinator.pushMapForSingleObject(object)
    }
}
