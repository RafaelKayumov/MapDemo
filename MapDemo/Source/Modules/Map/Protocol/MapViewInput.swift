//
//  MapViewInput.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation
import GEOSwift

protocol MapViewInput: class {

    func display(_ objects: Features)
}
