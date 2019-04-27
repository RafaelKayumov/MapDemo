//
//  MapViewOutput.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit

protocol MapViewOutput: ViewOutput {
    func onUserLocationUpdate(_ coordinate: CLLocation)
}
