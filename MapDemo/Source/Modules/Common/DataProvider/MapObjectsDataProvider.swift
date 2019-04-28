//
//  MapObjectsDataProvider.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import GEOSwift

private let kParkingsDataFileName = "parkingsData.json"
private let kRechargeStationsFileName = "rechargeStationsData.json"

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

    func loadData(_ boundingRect: BoundingRect? = nil, completion: @escaping (Features) -> Void) {
        let handler: (Result<Data, Error>, String) -> Void = { result, fileName in
            var dataToParse: Data?

            if case .success(let data) = result {
                dataToParse = data
                data.writeTo(fileName)
            } else {
                dataToParse = try? Data(contentsOf: URL.tempURLFor(fileName))
            }

            if let dataToParse = dataToParse {
                let features = (try? Features.fromGeoJSON(dataToParse)) ?? []
                completion(features)
            } else {
                completion([])
            }
        }

        rechargingStationsService.loadObjects(boundingRect) { result in
            handler(result, kRechargeStationsFileName)
        }

        paidParkingsService.loadObjects(boundingRect) { result in
            handler(result, kParkingsDataFileName)
        }
    }

    func fetchLocalData(_ boundingRect: BoundingRect? = nil, completion: @escaping (Features) -> Void) {
        var features = Features()
        if let parkingsData = try? Data(contentsOf: URL.tempURLFor(kParkingsDataFileName)) {
            let parkings = (try? Features.fromGeoJSON(parkingsData)) ?? []
            features += parkings
        }

        if let rechargingStationData = try? Data(contentsOf: URL.tempURLFor(kRechargeStationsFileName)) {
            let rechargingstations = (try? Features.fromGeoJSON(rechargingStationData)) ?? []
            features += rechargingstations
        }

        completion(features)
    }
}
