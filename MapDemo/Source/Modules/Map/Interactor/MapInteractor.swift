//
//  MapInteractor.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation

class MapInteractor {

    private unowned var dataProvider: MapObjectsDataProvider

    init(dataProvider: MapObjectsDataProvider) {
        self.dataProvider = dataProvider
    }
}

extension MapInteractor: MapViewOutput {

    func onViewReady() {
        dataProvider.loadData()
    }
}
