//
//  UIColor+Additions.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String, alpha: Double = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: CGFloat(alpha)
        )
    }

    static let clusterColor = UIColor(hex: "2D93AD")
    static let trackColor = UIColor(hex: "00B906")
}
