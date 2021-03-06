//
//  MapObjectsLoadingService.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 27/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation
import GEOSwift

class MapObjectsLoadingService {

    enum `Type` {
        case rechargeStation
        case paidParking
        case paidParkingArea
    }

   typealias LoadingCompletion = (Result<Data, Error>) -> Void

    private let transport: NetworkingTransport
    private var dataTask: URLSessionDataTask?
    private var type: Type
    init(transport: NetworkingTransport = NetworkingTransport(), type: Type) {
        self.transport = transport
        self.type = type
    }

    private func responseDataHandler(with completion: @escaping LoadingCompletion) -> NetworkingTransport.DataTaskCompletion {
        return { result in
            switch result {
            case .success(_, let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadObjects(_ boundingRect: BoundingRect?, with completion: @escaping LoadingCompletion) {
        var route: Route
        switch type {
        case .rechargeStation:
            route = .rechargeStations(boundingRect)
        case .paidParking:
            route = .paidParkings(boundingRect)
        case .paidParkingArea:
            route = .paidParkingAreas(boundingRect)
        }
        dataTask = transport.query(route, with: responseDataHandler(with: completion))
    }

    func cancelTask() {
        dataTask?.cancel()
        dataTask = nil
    }
}

private let kBaseURLString = "apidata.mos.ru"
private let kDatasetGeoJSONPath = "/v1/datasets/%d/features"
let kElectricChargerSetId = 2985
private let kPaidParkingAreasId = 1682
let kPaidParkingsId = 623
private let kBBox = "bbox"

extension MapObjectsLoadingService {

    enum Route: RouteProviding {
        case rechargeStations(BoundingRect?)
        case paidParkings(BoundingRect?)
        case paidParkingAreas(BoundingRect?)

        var path: String {
            switch self {
            case .rechargeStations:
                return String(format: kDatasetGeoJSONPath, kElectricChargerSetId)
            case .paidParkingAreas:
                return String(format: kDatasetGeoJSONPath, kPaidParkingAreasId)
            case .paidParkings:
                return String(format: kDatasetGeoJSONPath, kPaidParkingsId)
            }
        }

        var host: String {
            switch self {
            case .rechargeStations, .paidParkings, .paidParkingAreas:
                return kBaseURLString
            }
        }

        var queryParams: [String: String] {
            switch self {
            case .rechargeStations(let rect), .paidParkings(let rect), .paidParkingAreas(let rect):
                return [kBBox: rect?.string ?? ""]
            }
        }
    }
}
