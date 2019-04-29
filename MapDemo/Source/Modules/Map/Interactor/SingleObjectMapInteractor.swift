//
//  SingleObjectMapInteractor.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 29/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit
import GEOSwift

private let kSingleObjectZoomRegionSize: CLLocationDistance = 250

class SingleObjectMapInteractor {

    private unowned var view: MapViewController
    private var object: Feature

    init(object: Feature, view: MapViewController) {
        self.object = object
        self.view = view
    }
}

extension SingleObjectMapInteractor: MapViewOutput {

    func onUserLocationUpdate(_ coordinate: CLLocation) {
    }

    func onMapScroll(_ topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
    }

    func onFilterChange(_ option: FilterOptions, state: Bool) {
    }

    func onViewReady() {
        view.setFilterPanel(displayed: false)
        view.display([object])
        view.centerOnObject(object, squareSizeMeters: kSingleObjectZoomRegionSize)
    }
}
