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
import Cluster

class MapViewController: UIViewController, StoryboardBased {

    var output: MapViewOutput!

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var rechargingStationsSwitch: UISwitch!
    @IBOutlet private weak var parkingsSwitch: UISwitch!

    lazy var manager: ProperClusterManager = {
        let manager = ProperClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        output.onViewReady()
    }
}

private extension MapViewController {

    @IBAction func onRechargingStationsSwitch() {
        output.onFilterChange(.rechargingStations, state: rechargingStationsSwitch.isOn)
    }

    @IBAction func onParkingsSwitch() {
        output.onFilterChange(.parkings, state: parkingsSwitch.isOn)
    }
}

private extension MapViewController {

    func add(_ annotation: MKAnnotation) {
        manager.add(annotation)
        manager.reload(mapView: mapView)
    }

    func add(_ annotations: [MKAnnotation]) {
        manager.add(annotations)
        manager.reload(mapView: mapView)
    }

    func remove(_ annotation: MKAnnotation) {
        manager.remove(annotation)
        manager.reload(mapView: mapView)
    }

    func removeAllAnnotatoins() {
        manager.removeAll()
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
        let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
        let mainQueue = DispatchQueue.main

        backgroundQueue.async {
            let mapShapes = objects.compactMap { $0.geometries?.first?.mapShape() }
            let shapesCollection = mapShapes.compactMap { $0 as? MKShapesCollection }
            let overlays = mapShapes.compactMap { !($0 is MKShapesCollection) ? $0 : nil }
            let shapesToAdd = shapesCollection.flatMap { shapesCollection in
                shapesCollection.shapes
            }
            mainQueue.async {
                self.removeAllAnnotatoins()
                self.add(shapesToAdd)
                self.add(overlays)
            }
        }
    }

    func display(_ filter: FilterOptions) {
        parkingsSwitch.setOn(filter.contains(.parkings), animated: true)
        rechargingStationsSwitch.setOn(filter.contains(.rechargingStations), animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        output.onUserLocationUpdate(location)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        if let annotation = annotation as? ClusterAnnotation {
            return mapView.annotationView(of: CountClusterAnnotationView.self, annotation: annotation, reuseIdentifier: "cluster")
        } else {
            let identifier = "pin"
            let annotationView = mapView.annotationView(of: MKPinAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView)
        output.onMapScroll(mapView.topLeftCoordinate(), bottomRight: mapView.bottomRightCoordinate())
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer.trackRendererFor(polyline)
            return renderer
        } else if let polygon = overlay as? MKPolygon {
            return MKPolygonRenderer.trackRendererFor(polygon)
        }

        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}

extension MapViewController: ClusterManagerDelegate {

    func cellSize(for zoomLevel: Double) -> Double? {
        return nil
    }

    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return true
    }
}
