//
//  ProperClusterManager.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Cluster
import MapKit

class ProperClusterManager: ClusterManager {

    override func display(mapView: MKMapView, toAdd: [MKAnnotation], toRemove: [MKAnnotation]) {
        assert(Thread.isMainThread, "This function must be called from the main thread.")

        let basicAnnotationsToAdd = toAdd.filter { !($0 is MKOverlay) }
        let basicAnnotationsToRemove = toRemove.filter { !($0 is MKOverlay) }
        mapView.removeAnnotations(basicAnnotationsToRemove)
        mapView.addAnnotations(basicAnnotationsToAdd)

        if let spahesToAdd = (toAdd.filter { $0 is MKOverlay }) as? [MKOverlay] {
            mapView.addOverlays(spahesToAdd)
        }

        if let spahesToRemove = (toRemove.filter { $0 is MKOverlay }) as? [MKOverlay] {
            mapView.removeOverlays(spahesToRemove)
        }
    }
}
