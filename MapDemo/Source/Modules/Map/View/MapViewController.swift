//
//  MapViewController.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, StoryboardBased {

    var output: MapViewOutput!

    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        output.onViewReady()
    }
}
