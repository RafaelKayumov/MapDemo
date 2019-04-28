//
//  GeoObjectPresentable.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit
import GEOSwift

private let kAttributes = "Attributes"
private let kAddress = "Address"
private let kParkingName = "ParkingName"
private let kChargingStationName = "Name"
private let kDatasetId = "DatasetId"

extension ObjectType {

    init?(datasetId: Int) {
        switch datasetId {
        case kElectricChargerSetId:
            self = .rechargingStation
        case kPaidParkingsId:
            self = .parking
        default: return nil
        }
    }

    var image: UIImage {
        switch self {
        case .parking:
            return #imageLiteral(resourceName: "paidParking")
        case .rechargingStation:
            return #imageLiteral(resourceName: "rechargingStation")
        }
    }

    var objectNameKey: String {
        switch self {
        case .parking:
            return kParkingName
        case .rechargingStation:
            return kChargingStationName
        }
    }
}

struct GeoObjectPresentable {

    let image: UIImage?
    let name: String
    let address: String

    init(feature: Feature) {
        let attributes = feature.properties?[kAttributes] as? NSDictionary
        address = (attributes?[kAddress] as? String) ?? ""

        if let datasetId = feature.properties?[kDatasetId] as? Int, let objectType = ObjectType(datasetId: datasetId) {
            image = objectType.image
            name = (attributes?[objectType.objectNameKey] as? String) ?? ""
        } else {
            image = nil
            name = ""
        }
    }
}

extension Feature {

    func presentable() -> GeoObjectPresentable {
        return GeoObjectPresentable(feature: self)
    }
}
