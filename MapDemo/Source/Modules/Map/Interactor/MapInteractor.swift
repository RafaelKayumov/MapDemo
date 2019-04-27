//
//  MapInteractor.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit

private let kZoomRegionSizeMeters: CLLocationDistance = 3000

class MapInteractor {

    private unowned var dataProvider: MapObjectsDataProvider
    private unowned var view: MapViewController

    private var mapCentered = false

    init(dataProvider: MapObjectsDataProvider, view: MapViewController) {
        self.dataProvider = dataProvider
        self.view = view
    }
}

extension MapInteractor: MapViewOutput {

    func onViewReady() {
        dataProvider.loadData { features in
            DispatchQueue.main.async {
                self.view.display(features)
            }
        }
    }

    func onUserLocationUpdate(_ coordinate: CLLocation) {
        guard !mapCentered else { return }
        view.centerOnUser()
        view.applyZoom(kZoomRegionSizeMeters)
    }
}
