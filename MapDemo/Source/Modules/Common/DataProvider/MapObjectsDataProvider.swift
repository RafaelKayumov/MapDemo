//
//  MapObjectsDataProvider.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import GEOSwift

class MapObjectsDataProvider {

    private var paidParkingAreasService: MapObjectsLoadingService
    private var paidParkingsService: MapObjectsLoadingService
    private var rechargingStationsService: MapObjectsLoadingService

    init(paidParkingAreasService: MapObjectsLoadingService,
         paidParkingsService: MapObjectsLoadingService,
         rechargingStationsService: MapObjectsLoadingService) {
        self.paidParkingAreasService = paidParkingAreasService
        self.paidParkingsService = paidParkingsService
        self.rechargingStationsService = rechargingStationsService
    }

    func loadData(_ completion: @escaping (Features) -> Void) {
        let completion: MapObjectsLoadingService.LoadingCompletion = { result in
            if case .success(let results) = result {
                completion(results)
            }
        }

        rechargingStationsService.loadObjects(with: completion)
        paidParkingsService.loadObjects(with: completion)
    }
}
