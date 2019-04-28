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

enum ObjectType {
    case rechargingStation
    case parking

    var dataFileName: String {
        switch self {
        case .rechargingStation:
            return kRechargeStationsFileName
        case .parking:
            return kParkingsDataFileName
        }
    }
}

class MapObjectsDataProvider {

    private var paidParkingAreasService: MapObjectsLoadingService
    private var paidParkingsService: MapObjectsLoadingService
    private var rechargingStationsService: MapObjectsLoadingService
    var mapBoundingRect = BoundingRect.zero

    var filterOptions: FilterOptions = [.rechargingStations, .parkings]
    private(set) var parkings = Features()
    private(set) var rechargingStations = Features()
    private(set) var boundingRectObjects = Features()

    var allObjects: Features {
        var result = Features()
        if filterOptions.contains(.parkings) {
            result += parkings
        }
        if filterOptions.contains(.rechargingStations) {
            result += rechargingStations
        }
        return result
    }

    init(paidParkingAreasService: MapObjectsLoadingService,
         paidParkingsService: MapObjectsLoadingService,
         rechargingStationsService: MapObjectsLoadingService) {
        self.paidParkingAreasService = paidParkingAreasService
        self.paidParkingsService = paidParkingsService
        self.rechargingStationsService = rechargingStationsService
    }

    func loadData(_ boundingRect: BoundingRect? = nil, completion: @escaping (Features) -> Void) {
        let handler: (Result<Data, Error>, ObjectType) -> Void = { result, objectType in
            var dataToParse: Data?

            if case .success(let data) = result {
                dataToParse = data
                data.writeTo(objectType.dataFileName)
            } else {
                dataToParse = try? Data(contentsOf: URL.tempURLFor(objectType.dataFileName))
            }

            if let dataToParse = dataToParse {
                let features = (try? Features.fromGeoJSON(dataToParse)) ?? []

                switch objectType {
                case .rechargingStation:
                    self.rechargingStations = features
                case .parking:
                    self.parkings = features
                }

                completion(self.allObjects)
            } else {
                completion([])
            }
        }

        rechargingStationsService.loadObjects(boundingRect) { result in
            handler(result, .rechargingStation)
        }

        paidParkingsService.loadObjects(boundingRect) { result in
            handler(result, .parking)
        }
    }

    func fetchLocalData(_ boundingRect: BoundingRect? = nil, completion: @escaping (Features) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let parkingsData = try? Data(contentsOf: URL.tempURLFor(kParkingsDataFileName)) {
                let parkings = (try? Features.fromGeoJSON(parkingsData)) ?? []
                self.parkings = parkings
            }

            if let rechargingStationData = try? Data(contentsOf: URL.tempURLFor(kRechargeStationsFileName)) {
                let rechargingstations = (try? Features.fromGeoJSON(rechargingStationData)) ?? []
                self.rechargingStations = rechargingstations
            }

            DispatchQueue.main.async {
                completion(self.allObjects)
            }
        }
    }

    func objectsInBoundingRect() -> Features {
        guard let rectPolygon = Envelope(p1: Coordinate(mapBoundingRect.topLeft), p2: Coordinate(mapBoundingRect.bottomRight)) else {
            return []
        }
        return allObjects.filter {
            $0.geometries?.first?.intersects(rectPolygon) ?? false
        }
    }

    func bakeBoundingRectObjects() {
        boundingRectObjects = objectsInBoundingRect()
    }
}
