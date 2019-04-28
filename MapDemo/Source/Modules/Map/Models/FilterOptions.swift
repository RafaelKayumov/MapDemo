//
//  FilterOptions.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 29/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation

struct FilterOptions: OptionSet {
    let rawValue: Int

    static let rechargingStations = FilterOptions(rawValue: 1 << 0)
    static let parkings = FilterOptions(rawValue: 1 << 1)
}
