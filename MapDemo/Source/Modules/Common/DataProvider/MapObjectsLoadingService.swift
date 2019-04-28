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
    }

    typealias MapObjectsLoadingCompletion = (Result<Features, Error>) -> Void

    private let transport: NetworkingTransport
    private var dataTask: URLSessionDataTask?
    private var type: Type
    init(transport: NetworkingTransport = NetworkingTransport(), type: Type) {
        self.transport = transport
        self.type = type
    }

    private func responseDataHandler(with completion: @escaping MapObjectsLoadingCompletion) -> NetworkingTransport.DataTaskCompletion {
        return { result in
            switch result {
            case .success(_, let data):
                let features = (try? Features.fromGeoJSON(data)) ?? []
                completion(.success(features))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadObjects(with completion: @escaping MapObjectsLoadingCompletion) {
        var route: Route
        switch type {
        case .rechargeStation:
            route = .rechargeStationsList
        case .paidParking:
            route = .paidParkingList
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
private let kElectricChargerSetId = 2985
private let kPaidParkingAreasId = 1682
private let kPaidParkingsId = 623
private let kBBox = "bbox"

extension MapObjectsLoadingService {

    enum Route: RouteProviding {
        case rechargeStationsList
        case paidParkingList

        var path: String {
            switch self {
            case .rechargeStationsList:
                return String(format: kDatasetGeoJSONPath, kElectricChargerSetId)
            case .paidParkingList:
                return String(format: kDatasetGeoJSONPath, kPaidParkingsId)
            }
        }

        var host: String {
            switch self {
            case .rechargeStationsList, .paidParkingList:
                return kBaseURLString
            }
        }

        var queryParams: [String: String] {
            switch self {
            case .rechargeStationsList, .paidParkingList:
                return [:]
            }
        }
    }
}
