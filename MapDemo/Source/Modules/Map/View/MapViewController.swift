//
//  MapViewController.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit
import MapKit
import GEOSwift

class MapViewController: UIViewController, StoryboardBased {

    var output: MapViewOutput!

    @IBOutlet private weak var mapView: MKMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        output.onViewReady()
    }
}

extension MapViewController: MapViewInput {

    func applyZoom(_ squareSizeMeters: CLLocationDistance) {
        mapView.region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: squareSizeMeters, longitudinalMeters: squareSizeMeters)
    }

    func centerOnUser() {
        mapView.centerCoordinate = mapView.userLocation.coordinate
        mapView.showsUserLocation = true
    }

    func display(_ objects: Features) {
        mapView.addAnnotations(objects.compactMap { $0.geometries?.first?.mapShape() })
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        output.onUserLocationUpdate(location)
    }
}
