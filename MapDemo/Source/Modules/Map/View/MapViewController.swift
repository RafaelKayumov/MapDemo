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
        let overlays = objects.compactMap {
            $0.geometries?.first?.mapShape() as? MKShapesCollection
        }

        overlays.forEach {
            $0.shapes.forEach { shape in
                if let polygon = shape as? MKPolygon {
                    mapView.addOverlay(polygon)
                } else if let polyline = shape as? MKPolyline {
                    mapView.addOverlay(polyline)
                }
            }
        }

//        mapView.addOverlays(overlays)
//        mapView.addAnnotations(objects.compactMap {
//            MKShapesCollection
//            return $0.geometries?.first?.mapShape()
//        })
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        output.onUserLocationUpdate(location)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2.0
            return renderer
        } else if let plygon = overlay as? MKPolygon {
            return MKPolygonRenderer(overlay: plygon)
        } else {
            return MKPolygonRenderer(overlay: overlay)
        }
    }
}
