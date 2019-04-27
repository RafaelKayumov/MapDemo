//
//  MapObjectsDataProvider.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import GEOSwift

class MapObjectsDataProvider {

    private var paidParkingService: MapObjectsLoadingService
    private var rechargingStationsService: MapObjectsLoadingService

    init(paidParkingService: MapObjectsLoadingService, rechargingStationsService: MapObjectsLoadingService) {
        self.paidParkingService = paidParkingService
        self.rechargingStationsService = rechargingStationsService
    }

    func loadData(_ completion: @escaping (Features) -> Void) {
        rechargingStationsService.loadObjects { _ in
        }

        paidParkingService.loadObjects { result in
            if case .success(let results) = result {
                completion(results)
            }
        }
    }
}
