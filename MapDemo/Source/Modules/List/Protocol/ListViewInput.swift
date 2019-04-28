//
//  ListViewINput.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation

protocol ListViewInput: class {

    func refreshObjects()
    func display(_ presentables: [GeoObjectPresentable])
}
