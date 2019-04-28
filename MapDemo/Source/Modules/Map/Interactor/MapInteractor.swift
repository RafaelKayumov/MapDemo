//
//  MapInteractor.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit

private let kZoomRegionSizeMeters: CLLocationDistance = 3000

struct BoundingRect {

    var topLeft: CLLocationCoordinate2D
    var bottomRight: CLLocationCoordinate2D
    var representation: [CLLocationDegrees] {
        return [topLeft.longitude, topLeft.latitude, bottomRight.longitude, bottomRight.latitude]
    }
    var string: String {
        return representation.map { String($0) }.joined(separator: ",")
    }
    static var zero: BoundingRect {
        return BoundingRect(topLeft: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                            bottomRight: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}

class MapInteractor {

    private unowned var dataProvider: MapObjectsDataProvider
    private unowned var view: MapViewController

    private var mapCentered = false

    private var mapBoundingRect = BoundingRect.zero

    init(dataProvider: MapObjectsDataProvider, view: MapViewController) {
        self.dataProvider = dataProvider
        self.view = view
    }
}

extension MapInteractor: MapViewOutput {

    func onViewReady() {
        dataProvider.fetchLocalData { features in
            DispatchQueue.main.async {
                self.view.display(features)
            }
        }
    }

    func onUserLocationUpdate(_ coordinate: CLLocation) {
        guard !mapCentered else { return }
        mapCentered = true
        view.centerOnUser()
        view.applyZoom(kZoomRegionSizeMeters)

        dataProvider.loadData { features in
            DispatchQueue.main.async {
                self.view.display(features)
            }
        }
    }

    func onMapScroll(_ topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
        mapBoundingRect.topLeft = topLeft
        mapBoundingRect.bottomRight = bottomRight
    }
}
