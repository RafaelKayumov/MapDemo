//
//  ListViewOutput.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation
import GEOSwift

protocol ListViewOutput: ViewOutput {

    func onWillAppear()
    func triggerObjectsRefresh()
    func objectFor(_ index: Int) -> Feature?
}
