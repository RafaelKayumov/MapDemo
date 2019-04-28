//
//  MKPolygonRenderer+Additions.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit

extension MKPolygonRenderer {

    static func trackRendererFor(_ overlay: MKOverlay) -> MKPolygonRenderer {
        let renderer = self.init(overlay: overlay)
        renderer.strokeColor = .trackColor
        renderer.lineWidth = 2.0
        renderer.lineCap = .butt
        renderer.fillColor = .trackFillColor
        return renderer
    }
}
