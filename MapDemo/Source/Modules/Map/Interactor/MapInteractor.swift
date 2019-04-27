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
    private unowned var view: MapViewController

    init(dataProvider: MapObjectsDataProvider, view: MapViewController) {
        self.dataProvider = dataProvider
        self.view = view
    }
}

extension MapInteractor: MapViewOutput {

    func onViewReady() {
        dataProvider.loadData {
            self.view.display($0)
        }
    }
}
