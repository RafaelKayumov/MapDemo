//
//  ObjectCell.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit
import GEOSwift

class ObjectCell: UITableViewCell {

    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    func configureWith(_ geoObjectPresentable: GeoObjectPresentable) {
        typeImageView.image = geoObjectPresentable.image
        nameLabel.text = geoObjectPresentable.name
        addressLabel.text = geoObjectPresentable.address
    }
}
