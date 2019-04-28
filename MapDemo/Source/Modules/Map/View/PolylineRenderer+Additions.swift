//
//  PolylineRenderer+Additions.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import MapKit

extension MKPolylineRenderer {

    static func trackRendererFor(_ overlay: MKOverlay) -> MKPolylineRenderer {
        let renderer = self.init(overlay: overlay)
        renderer.strokeColor = .trackColor
        renderer.lineWidth = 5.0
        renderer.lineCap = .butt
        return renderer
    }
}
